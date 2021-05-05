class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @my_trainings = Training.includes(:training_workshops).joins(training_workshops: :attendees).where(attendees: {user_id: current_user.id, status: 'Registered'}).where.not('date < ?', Date.today).uniq
    @completed_workshops = TrainingWorkshop.joins(:attendees).where(attendees: {user_id: current_user.id, status: 'Completed'})
    @my_workshops = TrainingWorkshop.joins(:attendees).where(attendees: {user_id: current_user.id, status: 'Registered'}).where.not('date < ?', Date.today)
    if ['Super Admin', 'Admin', 'HR'].include?(current_user.access_level)
      @available_workshops = TrainingWorkshop.joins(:workshop).where(training_id: nil, workshops: {company_id: current_user.company_id}).where.not(date: nil).where.not('date < ?', Date.today) - @my_workshops
      @available_trainings = Training.where(company_id: current_user.company_id) - @my_trainings
    else
      @available_workshops = TrainingWorkshop.joins(:attendees).where(attendees: {user_id: current_user.id, status: 'Invited'}).where.not('date < ?', Date.today)
      @available_trainings = Training.includes(:training_workshops).joins(training_workshops: :attendees).where(attendees: {user_id: current_user.id, status: 'Invited'}).where.not('date < ?', Date.today).uniq
    end
  end

  def calendar_month
    @workshops = TrainingWorkshop.joins(:workshop).where(workshops: {company_id: current_user.company_id})
  end

  def calendar_week
    @workshops = TrainingWorkshop.joins(:workshop).where(workshops: {company_id: current_user.company_id})
  end

  def catalogue
    # Index with 'search' option and global visibility for SEVEN Users
    if current_user.access_level == 'Super Admin'
      @training_programs = TrainingProgram.all.order(title: :asc)
      @workshops = Workshop.all.order(title: :asc)
      if params[:search]
        @training_programs = ((TrainingProgram.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)) + (TrainingProgram.joins(program_workshops: :workshop).where("lower(workshops.title) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
        @workshops = Workshop.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
      elsif params[:filter]
        @training_programs = TrainingProgram.joins(workshops: :workshop_categories).where(workshop_categories: {category_id: params[:filter].map(&:to_i)}).order(title: :asc)
        @workshops = Workshop.joins(:workshop_categories).where(workshop_categories: {category_id: params[:filter].map(&:to_i)}).order(title: :asc)
      end
    # Index for other Users, with visibility limited to programs proposed by their company only
    else
      @training_programs = TrainingProgram.joins(:company).where(companies: { name: current_user.company.name }).order(title: :asc)
      @workshops = Workshop.where(company_id: current_user.company.id).order(title: :asc)
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
    @tags = Tag.joins(:company).where(companies: {id: current_user.company_id})
  end

  def catalogue_filter_workshop
    @workshop_categories = params[:workshop][:category_ids].drop(1).map(&:to_i)
    # @workshop_categories = Category.where(company_id: current_user.company_id).map(&:id) if params[:filter][:all] == '1'
    @all = 'true' if params[:filter][:all] == '1'
    respond_to do |format|
      format.html {redirect_to catalogue_path}
      format.js
    end
  end

  def catalogue_filter_program
    if params[:filter][:all] == '1'
      @program_categories = Category.where(company_id: current_user.company_id).map(&:id)
    else
      @program_categories = params[:training_program][:category_ids].drop(1).map(&:to_i)
    end
    respond_to do |format|
      format.html {redirect_to catalogue_path}
      format.js
    end
  end

  def catalogue_programs_title_order_asc
    respond_to do |format|
      format.html {redirect_to catalogue_path}
      format.js
    end
  end

  def catalogue_programs_title_order_desc
    respond_to do |format|
      format.html {redirect_to catalogue_path}
      format.js
    end
  end
def catalogue_programs_duration_order_asc
    respond_to do |format|
      format.html {redirect_to catalogue_path}
      format.js
    end
  end

  def catalogue_programs_duration_order_desc
    respond_to do |format|
      format.html {redirect_to catalogue_path}
      format.js
    end
  end

  private

  def index_function(parameter)
    if ['Super Admin', 'HR'].include?(current_user.access_level)
      if params[:search].present?
        @users = (parameter.where(company_id: current_user.company.id).where('lower(firstname) LIKE ?', "%#{params[:search][:name].downcase}%") + parameter.where('lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%"))
        @users = @users.sort_by{ |user| user.lastname } if @users.present?
      elsif params[:filter].present? && (params[:filter][:job] != [""] || params[:filter][:tag].reject{|x|x.empty?} != [])
        tags = Tag.where(tag_name: params[:filter][:tag].reject(&:blank?)).map{|x| x.id}
        if params[:filter][:job] != [""] && params[:filter][:job].present?
          if tags.present?
            @users = (parameter.joins(:user_tags).where(company_id: current_user.company_id, job_description: params[:filter][:job].reject(&:blank?), user_tags: {tag_id: Tag.where(tag_name: params[:filter][:tag].reject(&:blank?)).map{|x| x.id}}).uniq)
          else
            @users = (parameter.where(company_id: current_user.company_id, job_description: params[:filter][:job].reject(&:blank?)))
          end
        else
          @users = (parameter.joins(:user_tags).where(company_id: current_user.company_id, user_tags: {tag_id: Tag.where(tag_name: params[:filter][:tag].reject(&:blank?)).map{|x| x.id}}).uniq)
        end
      else
        @users = parameter.where(company_id: current_user.company.id).order('lastname ASC')
      end
    end
  end
end
