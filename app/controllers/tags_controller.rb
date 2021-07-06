class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :destroy]

  # Create a new tag for the selected tag_category (pages/organisation)
  def create
    @tag = Tag.new(tag_params)
    authorize @tag
    @tag.company_id = current_user.company_id
    if @tag.save
      @tag_categories = TagCategory.where(company_id: current_user.company_id).order(position: :asc)
      @users = User.where(id: params[:tag][:users].split(' '))
      @opened = params[:button]
      if params[:ajax].present?
        respond_to do |format|
          format.html {redirect_to organisation_path}
          format.js
        end
      else
        redirect_back(fallback_location: root_path)
      end
    end
  end

  # Update a tag (pages/organisation)
  def update_tag
    @tag = Tag.find(params[:tag][:tag_id])
    authorize @tag
    if @tag.tag_category == TagCategory.where(company_id: current_user.company_id).order(:id).first
      User.where(company_id: current_user.company_id, job_title: @tag.tag_name).each do |user|
        user.update(job_title: params[:tag][:tag_name])
      end
    end
    @tag.update(tag_params)
    @tag_categories = TagCategory.where(company_id: current_user.company_id).order(position: :asc)
    @users = User.where(id: params[:tag][:users].split(' '))
    @opened = params[:button]
    respond_to do |format|
      format.html {redirect_to organisation_path}
      format.js
    end
  end

  # Delete selected tag (pages/organisation)
  def destroy
    @tag = Tag.find(params[:id])
    authorize @tag
    @tag.destroy
    @tag_categories = TagCategory.where(company_id: current_user.company_id).order(position: :asc)
    @opened = params[:tag_category_id]
    respond_to do |format|
      format.html {redirect_to organisation_path}
      format.js
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:tag_name, :image, :tag_category_id)
  end
end
