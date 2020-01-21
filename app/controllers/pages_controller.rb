class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @my_trainings = Training.joins(:attendees).where(attendees: {user_id: current_user.id})
    @workshops = TrainingWorkshop.all
    @my_workshops = TrainingWorkshop.joins(training: :attendees).where(attendees: {user_id: current_user.id})
    @available_workshops = TrainingWorkshop.joins(:training).where(trainings: {company_id: current_user.company_id}).where.not(date: nil) - @my_workshops
  end

  def catalogue
    # Index with 'search' option and global visibility for SEVEN Users
    if current_user.access_level == 'Super Admin'
      @training_programs = TrainingProgram.all
      @workshops = Workshop.all
      if params[:search]
        @training_programs = ((TrainingProgram.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)) + (TrainingProgram.joins(program_workshops: :workshop).where("lower(workshops.title) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
        @workshops = Workshop.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
      elsif params[:filter]
        @training_programs = TrainingProgram.joins(workshops: :workshop_categories).where(workshop_categories: {category_id: params[:filter].map(&:to_i)})
        @workshops = Workshop.joins(:workshop_categories).where(workshop_categories: {category_id: params[:filter].map(&:to_i)})
      end
    # Index for other Users, with visibility limited to programs proposed by their company only
    else
      @training_programs = TrainingProgram.joins(:company).where(companies: { name: current_user.company.name })
      @workshops = Workshop.where(company_id: current_user.company.id)
      if params[:search]
        @training_programs = @training_programs.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
      end
    end
    @training = Training.new
  end

  def filter_catalogue
    category_ids = params[:workshop][:category_ids].drop(1).map(&:to_i)
    redirect_to catalogue_path(filter: category_ids)
  end
end
