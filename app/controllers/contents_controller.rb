class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :duplicate]
  before_action :force_json, only: [:change_author]
  helper VideoHelper

  # Create new content (pages/catalogue)
  def create
    params.permit!
    @content = Content.new(params[:content].except(:categories))
    authorize @content
    @content.company_id = current_user.company.id
    if @content.save
      params[:content][:categories].split(',').each do |category_id|
        ContentCategory.create(content_id: @content.id, category_id: category_id)
      end
      redirect_to edit_content_path(@content)
    end
  end

  # Show content view_mode
  def show
    authorize @content
  end

  # Show content edit_mode
  def edit
    authorize @content
  end

  # Update content attributes
  def update
    authorize @content
    @content.update(content_params)
    if @content.save
      respond_to do |format|
        format.html {edit_mode_content_path(@content)}
        format.js
      end
    end
  end

  # Delete content (pages/catalogue)
  def destroy
    @content = Content.find(params[:id])
    authorize @content
    @content.destroy
    redirect_to catalogue_path
  end

  # Duplicate content (pages/catalogue)
  def duplicate
    authorize @content
    @new_content = Content.new(@content.attributes.except("id", "created_at", "updated_at"))
    @new_content.title = @content.title + ' - Duplicate'
    if @new_content.save
      @content.categories.each do |category|
        ContentCategory.create(content_id: @new_content.id, category_id: category.id)
      end
      @content.mods.each do |mod|
        new_mod = Mod.new(mod.attributes.except("id", "created_at", "updated_at", "content_id"))
        new_mod.content_id = @new_content.id
        new_mod.save
        new_mod.text = mod.text.dup
        new_mod.text.record_id = new_mod.id
        new_mod.text.update(body: mod.text.body.dup)
      end
      redirect_to edit_mode_content_path(@new_content, redirect_from: 'edit')
    end
  end

  # Manage content_categories (contents/edit_mode)
  def content_link_category
    skip_authorization
    if params[:new_category].present?
      Category.create(company_id: current_user.company_id, title: params[:new_category][:title])
      @content = Content.find(params[:new_category][:content_id])
      @modal = 'true'
    elsif params[:delete].present?
      Category.find(params[:category_id]).destroy
      @content = Content.find(params[:content_id])
      @modal = 'true'
    elsif params[:add_categories].present?
      @action = params[:add_categories][:page]
      @content = Content.find(params[:add_categories][:content_id])
      ids = params[:content][:categories].reject{|x| x.empty?}
      ids.each do |category_id|
        unless ContentCategory.find_by(content_id: @content.id, category_id: category_id).present?
          ContentCategory.create(content_id: @content.id, category_id: category_id)
        end
      end
      ContentCategory.where(content_id: @content.id).where.not(category_id: ids).each do |content_category|
        content_category.destroy
      end
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def set_content
    @content = Content.find(params[:id])
  end

  def content_params
    params.require(:content).permit(:title, :description, :duration, :image, :content, :content_type)
  end

  def force_json
    request.format = :json
  end
end
