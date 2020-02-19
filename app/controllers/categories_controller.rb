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
    @category.save ? (redirect_to catalogue_path) : (render :new)
  end

  def edit
    authorize @category
  end

  def update
    authorize @category
    @category.update(category_params)
    @category.save ? (redirect_to catalogue_path) : (render '_edit')
  end

  def destroy
    @category.destroy
    authorize @category
    redirect_to catalogue_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:title, :description)
  end
end
