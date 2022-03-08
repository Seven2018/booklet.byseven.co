class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy, :duplicate]

  # Duplicate content (pages/catalogue)
  def duplicate
    authorize @folder
    @new_folder = Folder.new(@folder.attributes.except("id", "created_at", "updated_at"))
    @new_folder.title = @folder.title + ' - Duplicate'
    if @new_folder.save
      @folder.categories.each do |category|
        FolderCategory.create(folder_id: @new_folder.id, category_id: category.id)
      end
    
      redirect_to edit_folder_path(@new_folder)
    end
  end

  def show
    @folder = Folder.find(params[:id])
    authorize @folder
  end

  def edit
    @folder = Folder.find(params[:id])
    @folders = Folder.where(company_id: current_user.company_id).where('id != ?', params[:id]).order(title: :asc)
    if params[:search].present? && !params[:search][:title].blank?
      @folders = @folders.search_folders("#{params[:search][:title]}")
    end
    @folders = @folders.reject{|x| x.children_folders_all.include?(@folder)} - @folder.children_folders_all(true)
    @contents = Content.where(company_id: current_user.company_id).order(title: :asc)
    if params[:search].present? && !params[:search][:title].blank?
      @contents = @contents.search("#{params[:search][:title]}")
    end
    authorize @folder
    respond_to do |format|
      format.html {edit_folder_path(@folder)}
      format.js
    end
  end

  def update
    authorize @folder
    @folder.update(folder_params)
    if @folder.save
      respond_to do |format|
        format.html {edit_mode_folder_path(@folder)}
        format.js
      end
    end
  end

  # Create new folder (pages/catalogue)
  def create
    params.permit!
    @folder = Folder.new(params[:folder].except(:categories))
    authorize @folder
    @folder.company_id = current_user.company.id
    if @folder.save
      params[:folder][:categories].split(',').each do |category_id|
        FolderCategory.create(folder_id: @folder.id, category_id: category_id)
      end
      redirect_to edit_folder_path(@folder)
    end
  end

  def destroy
    @folder = Folder.find(params[:id])
    authorize @folder
    @folder.destroy
    redirect_to catalogue_path
  end

  def folder_manage_children
    @folder = Folder.find(params[:select_children][:folder_id])
    return if @folder.company_id != current_user.company_id
    authorize @folder
    folders = params[:select_children][:folder_ids].split(',')
    contents = params[:select_children][:content_ids].split(',')
    folders.each do |folder_id|
      FolderLink.create(parent_id: @folder.id, child_id: folder_id)
    end
    contents.each do |content_id|
      ContentFolderLink.create(folder_id: @folder.id, content_id: content_id)
    end
    FolderLink.where(parent_id: @folder.id).where.not(child_id: folders).destroy_all
    ContentFolderLink.where(folder_id: @folder.id).where.not(content_id: contents).destroy_all
    return
  end

  # Manage folder_categories (folders/edit_mode)
  def folder_link_category
    skip_authorization
    if params[:new_category].present?
      Category.create(company_id: current_user.company_id, title: params[:new_category][:title])
      @folder = Folder.find(params[:new_category][:folder_id])
      @modal = 'true'
    elsif params[:delete].present?
      Category.find(params[:category_id]).destroy
      @folder = Folder.find(params[:folder_id])
      @modal = 'true'
    elsif params[:add_categories].present?
      @action = params[:add_categories][:page]
      @folder = Folder.find(params[:add_categories][:folder_id])
      ids = params[:folder][:categories].reject{|x| x.empty?}
      ids.each do |category_id|
        unless FolderCategory.find_by(folder_id: @folder.id, category_id: category_id).present?
          FolderCategory.create(folder_id: @folder.id, category_id: category_id)
        end
      end
      FolderCategory.where(folder_id: @folder.id).where.not(category_id: ids).each do |folder_category|
        folder_category.destroy
      end
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def set_folder
    @folder = Folder.find(params[:id])
  end

  def folder_params
    params.require(:folder).permit(:title, :description)
  end
end
