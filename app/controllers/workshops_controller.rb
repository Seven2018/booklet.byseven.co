class WorkshopsController < ApplicationController
  before_action :set_workshop, only: [:show, :view_mode, :edit, :update, :destroy]
  helper VideoHelper

  # def index
  #   # Index with 'search' option and global visibility for SEVEN Users
  #   if current_user.access_level == 'Super Admin'
  #     @workshops = policy_scope(Workshop)
  #     if params[:search]
  #       @workshops = ((Workshop.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)) + (Workshop.joins(:company).where("lower(companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
  #     elsif params[:filter]
  #       @workshops = Workshop.joins(:workshop_categories).where(workshop_categories: {category_id: params[:filter].map(&:to_i)})
  #     end
  #   # Index for other Users, with visibility limited to programs proposed by their company only
  #   else
  #     @workshops = policy_scope(Workshop)
  #     @workshops = Workshop.where(company_id: current_user.company.id)
  #     if params[:search]
  #       @workshops = @workshops.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
  #     end
  #   end
  # end

  def show
    authorize @workshop
    @workshop_skill = WorkshopSkill.new
    @workshop_category = WorkshopCategory.new
  end

  def view_mode
    authorize @workshop
  end

  def new
    @workshop = Workshop.new
    authorize @workshop
    @workshop_category = WorkshopCategory.new
  end

  def create
    @workshop = Workshop.new(workshop_params)
    authorize @workshop
    @workshop.company_id = current_user.company.id
    @workshop.author_id = current_user.id
    if @workshop.save

      # # Links Workshop to Categories through joined table
      # array = params[:workshop][:category_ids].drop(1).map(&:to_i)
      # array.each do |ind|
      #   if WorkshopCategory.where(workshop_id: @workshop.id, category_id: ind).empty?
      #     WorkshopCategory.create(workshop_id: @workshop.id, category_id: ind)
      #   end
      # end
      # # Select all Categories whose checkbox is unchecked and destroy their WorkshopCategory, if existing
      # (Category.ids - array).each do |ind|
      #   unless WorkshopCategory.where(workshop_id: @workshop.id, category_id: ind).empty?
      #     WorkshopCategory.where(workshop_id: @workshop.id, category_id: ind).first.destroy
      #   end
      # end

      redirect_to workshop_path(@workshop)
    else
      render :new
    end
  end

  def edit
    authorize @workshop
  end

  def update
    authorize @workshop
    @workshop.update(workshop_params)
    if @workshop.save
      redirect_to workshop_path(@workshop)
    else
      render :edit
    end
  end

  def destroy
    @workshop.destroy
    authorize @workshop
    redirect_back(fallback_location: root_path)
  end

  def filter
    @workshops = @workshops = Workshop.where(company_id: current_user.company.id)
    authorize @workshops
    category_ids = params[:workshop][:category_ids].drop(1).map(&:to_i)
    redirect_to workshops_path(filter: category_ids)
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
  end

  def workshop_params
    params.require(:workshop).permit(:title, :description, :duration, :image, :content, :workshop_type)
  end
end
