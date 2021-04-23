class TrainingWorkshopsController < ApplicationController
  before_action :set_training_workshop, only: [:show, :view_mode, :update, :destroy]
  helper VideoHelper

  def show
    @training_workshop = TrainingWorkshop.find(params[:id])
    authorize @training_workshop
    ['Super Admin', 'Admin', 'HR'].include?(current_user.access_level) ? @tags = Tag.where(company_id: current_user.company_id) : @tags = current_user.tags
    @users = User.where(company_id: current_user.company_id)
  end

  def view_mode
    authorize @training_workshop
    @workshop = Workshop.find(@training_workshop.workshop_id)
  end

  # Allows management of TrainingWorkshops through a checkbox collection
  def create
    @training_workshop = TrainingWorkshop.new
    authorize @training_workshop
    @training = Training.find(params[:training_id])
    # Select all Workshops whose checkbox is checked and create a TrainingWorkshop
    array = params[:training][:workshop_ids].uniq.drop(1).map(&:to_i)
    array.each do |ind|
      workshop = Workshop.find(ind)
      if TrainingWorkshop.where(workshop_id: ind).empty?
        new_training_workshop = TrainingWorkshop.create(workshop.attributes.except("id", "created_at", "updated_at"))
        new_training_workshop.update(training_id: @training.id, workshop_id: ind)
      end
    end
    # Select all Workshops whose checkbox is unchecked and destroy their TrainingWorkshop, if existing
    (Workshop.ids - array).each do |ind|
      unless TrainingWorkshop.where(training_id: @training.id, workshop_id: ind).empty?
        TrainingWorkshop.where(training_id: @training.id, workshop_id: ind).first.destroy
      end
    end
    redirect_to training_path(@training)
  end

  def update
    @training_workshop = TrainingWorkshop.find(params[:id])
    authorize @training_workshop
    @training_workshop.update(training_workshop_params)
    redirect_back(fallback_location: root_path) if @training_workshop.save
  end

  def copy
    @training_workshop = TrainingWorkshop.find(params[:id])
    authorize @training_workshop
    new_training_workshop = TrainingWorkshop.new(@training_workshop.attributes.except("id", "created_at", "updated_at"))
    new_training_workshop.title = params[:copy][:title]
    new_training_workshop.date = params[:copy][:date]
    redirect_to training_path(@training_workshop.training) if new_training_workshop.save
  end

  def book_training_workshop
    workshop = Workshop.find(params[:id].to_i)
    @training_workshop = TrainingWorkshop.create(workshop.attributes.except("id", "created_at", "updated_at", "author_id"))
    @training_workshop.workshop_id = workshop.id
    skip_authorization
    if @training_workshop.save
      @training_workshop.update(training_workshop_params)
      respond_to do |format|
        format.html {redirect_to training_workshop_path(@training_workshop)}
        format.js
      end
    end
  end

  def update_book_training_workshop
    skip_authorization
    @training_workshop = TrainingWorkshop.find(params[:id])
    @training_workshop.update(training_workshop_params)
    if @training_workshop.save
      @training_workshop.update(training_workshop_params)
      respond_to do |format|
        format.html {redirect_to training_workshop_path(@training_workshop)}
        format.js
      end
    end
  end

  def destroy
    authorize @training_workshop
    @training_workshop.destroy
    redirect_to dashboard_path
  end

  private

  def set_training_workshop
    @training_workshop = TrainingWorkshop.find(params[:id])
  end

  def training_workshop_params
    params.require(:training_workshop).permit(:title, :duration, :participant_number, :description, :content, :image, :date, :available_date, :starts_at, :ends_at)
  end
end
