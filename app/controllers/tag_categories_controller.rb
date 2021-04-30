class TagCategoriesController < ApplicationController
  def create
    @tag_category = TagCategory.new(tag_category_params)
    authorize @tag_category
    @tag_category.company_id = current_user.company_id
    if @tag_category.save
      if params[:ajax].present?
        respond_to do |format|
          format.html {redirect_to organisation_path}
          format.js
        end
      else
        redirect_back(fallback_location: root_path)
      end
    else
      raise
    end
  end

  def delete_tag_category
    @tag_category = TagCategory.find(params[:tag_category][:id])
    authorize @tag_category
    @tag_category.destroy
    respond_to do |format|
      format.html {redirect_to organisation_path}
      format.js
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_category_params
    params.require(:tag_category).permit(:name)
  end
end
