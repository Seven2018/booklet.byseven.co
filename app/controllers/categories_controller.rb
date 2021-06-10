class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # Index with "search" option
  def index
    params[:search] ? @categories = policy_scope(Category).where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc) : @categories = policy_scope(Category).order(title: :asc)
  end

  def show
    authorize @category
  end

  def new
    @category = Category.new
    authorize @category
  end

  def create
    @category = Category.new(category_params)
    authorize @category
    @category.company_id = current_user.company_id
    @category.title = 'Sans titre' if @category.title == ''
    if @category.save
      if params[:ajax].present?
        respond_to do |format|
          format.html {redirect_to catalogue_path}
          format.js
        end
      else
        redirect_to catalogue_path
      end
    end
  end

  def edit
    authorize @category
  end

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

  def destroy
    @category.destroy
    authorize @category
    if params[:ajax].present?
      respond_to do |format|
        format.html {redirect_to catalogue_path}
        format.js
      end
    else
      redirect_to catalogue_path
    end
  end

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
    params.require(:category).permit(:title, :description)
  end
end
