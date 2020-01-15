class WorkshopsController < ApplicationController
  before_action :set_workshop, only: [:show, :edit, :update, :destroy]

  def index
    # Index with 'search' option and global visibility for SEVEN Users
    if current_user.access_level == 'Super Admin'
      @workshops = policy_scope(Workshop)
      if params[:search]
        @workshops = ((Workshop.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)) + (Workshop.joins(:company).where("lower(companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
      end
    # Index for other Users, with visibility limited to programs proposed by their company only
    else
      @workshops = policy_scope(Workshop)
      @workshops = Workshop.where(company_id: current_user.company.id )
      if params[:search]
        @workshops = @workshops.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
      end
    end
  end

  def show
    authorize @workshop
  end

  def new
    @workshop = Workshop.new
    authorize @workshop
  end

  def create
    @workshop = Workshop.new(workshop_params)
    authorize @workshop
    @workshop.company_id = current_user.company.id
    if @workshop.save
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
    redirect_to workshop_path
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
  end

  def workshop_params
    params.require(:workshop).permit(:title, :description, :duration, :image, :content)
  end
end
