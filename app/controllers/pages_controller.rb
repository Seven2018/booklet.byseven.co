class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @my_trainings = Training.includes(:training_workshops).joins(training_workshops: :attendees).where(attendees: {user_id: current_user.id}).where.not('date < ?', Date.today).uniq
    @workshops = TrainingWorkshop.joins(:workshop).where(workshops: {company_id: current_user.company_id})
    @completed_workshops = TrainingWorkshop.joins(:attendees).where(attendees: {user_id: current_user.id, status: 'Completed'})
    @my_workshops = TrainingWorkshop.joins(:attendees).where(attendees: {user_id: current_user.id}).where.not('date < ?', Date.today)
    if ['Super Admin', 'Admin', 'HR'].include?(current_user.access_level)
      @available_workshops = TrainingWorkshop.joins(:workshop).where(training_id: nil, workshops: {company_id: current_user.company_id}).where.not(date: nil).where.not('date < ?', Date.today)
      @available_trainings = Training.where(company_id: current_user.company_id).sort_by(&:first_date) - @my_trainings
    else
      @available_workshops = TrainingWorkshop.joins(workshop: {categories: :team_categories}).where(training_id: nil, workshops: {company_id: current_user.company_id}, team_categories: {team_id: [current_user.teams.ids]}).where.not(date: nil) - @my_workshops
      @available_trainings = Training.joins(training_program: {categories: :team_categories}).where(company_id: current_user.company_id, team_categories: {team_id: [current_user.teams.ids]}).sort_by(&:first_date) - @my_trainings
    end
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

  def organisation
    # Index with 'search' option and global visibility for SEVEN Users
    index_function(User.all)
    # Index for other Users, with visibility limited to programs proposed by their company only
    if current_user.access_level == 'Super Admin'
      @teams = Team.joins(:company).where(companies: { name: current_user.company.name })
      if params[:search]
        @teams = @teams.where("lower(name) LIKE ?", "%#{params[:search][:name].downcase}%").order(name: :asc)
      end
    end
    @training = Training.new
  end

  def filter_catalogue
    category_ids = params[:workshop][:category_ids].drop(1).map(&:to_i)
    redirect_to catalogue_path(filter: category_ids)
  end

  private

  def index_function(parameter)
    if current_user.access_level == 'Super Admin'
    #   if params[:search]
    #     @users = (parameter.where('lower(firstname) LIKE ?', "%#{params[:search][:name].downcase}%") + parameter.where('lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%"))
    #     @users = @users.sort_by{ |user| user.lastname } if @users.present?
    #   else
    #     @users = parameter.order('lastname ASC')
    #   end
    # elsif current_user.access_level == 'HR'
      if params[:search]
        @users = (parameter.where(company_id: current_user.company.id).where('lower(firstname) LIKE ?', "%#{params[:search][:name].downcase}%") + parameter.where('lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%"))
        @users = @users.sort_by{ |user| user.lastname } if @users.present?
      else
        @users = parameter.where(company_id: current_user.company.id).order('lastname ASC')
      end
    end
  end
end
