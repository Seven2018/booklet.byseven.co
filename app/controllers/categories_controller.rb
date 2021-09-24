class CategoriesController < ApplicationController
  before_action :set_category, only: [:update, :destroy]

  # Create a new category (contents/edit_mode or pages/catalogue)
  def create
    @category = Category.new(category_params)
    authorize @category
    @category.company_id = current_user.company_id
    @category.title = 'Sans titre' if @category.title == ''
    @page = params[:category][:page]
    if @category.save
      respond_to do |format|
        format.js
      end
    end
  end

  # Update a category (contents/edit_mode or pages/catalogue)
  def update
    authorize @category
    @category.update(category_params)
    if @category.save
      if params[:category][:ajax].present?
        respond_to do |format|
          format.html {redirect_to catalogue_path}
          format.js
        end
      else
        redirect_to catalogue_path
      end
    end
  end

  # Delete a category (contents/edit_mode or pages/catalogue)
  def destroy
    authorize @category
    @page = params[:page]
    @category.destroy
    respond_to do |format|
      format.js
    end
  end

  # Search from categories with autocomplete
  def categories_search
    skip_authorization
    if params[:search].present?
      @categories = Category.where(company_id: current_user.company_id).ransack(title_cont: params[:search]).result(distinct: true)
    else
      @categories = Category.where(company_id: current_user.company_id)
    end
    respond_to do |format|
      format.json {
        @users = @categories.limit(5)
      }
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:title)
  end
end
