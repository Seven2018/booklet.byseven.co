class TagCategoriesController < ApplicationController
  def create
    @tag_category = TagCategory.new(tag_category_params)
    authorize @tag_category
    @tag_category.company_id = current_user.company_id
    if @tag_category.save
      redirect_back(fallback_location: root_path)
    else
      raise
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
