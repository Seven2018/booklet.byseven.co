class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :duplicate]

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

  private

  def set_folder
    @folder = Folder.find(params[:id])
  end

  def folder_params
    params.require(:folder).permit(:title, :description)
  end
end
