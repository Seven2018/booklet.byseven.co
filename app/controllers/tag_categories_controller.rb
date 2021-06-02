class TagCategoriesController < ApplicationController
  def create
    @tag_category = TagCategory.new(tag_category_params)
    authorize @tag_category
    @tag_category.company_id = current_user.company_id
    @tag_category.position = TagCategory.where(company_id: current_user.company_id).count + 1
    @users = User.where(id: params[:tag_category][:users].split(' '))
    if @tag_category.save
      @tag_categories = TagCategory.where(company_id: current_user.company_id).order(position: :asc)
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

  def destroy
    @tag_category = TagCategory.find(params[:id])
    authorize @tag_category
    @users = User.where(id: params[:users].split(' '))
    @tag_categories = TagCategory.where(company_id: current_user.company_id).order(position: :asc)
    TagCategory.where(company_id: current_user.company_id).where('position > ?', @tag_category.position).each{|x| x.update(position: x.position - 1)}
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
