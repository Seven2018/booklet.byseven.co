class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @completed_workshops = TrainingWorkshop.joins(:attendees).where(attendees: {user_id: current_user.id, status: 'Completed'})
    @my_workshops = TrainingWorkshop.joins(:attendees).where(attendees: {user_id: current_user.id, status: 'Registered'}).where.not('date < ?', Date.today)
    if ['Super Admin', 'Admin', 'HR'].include?(current_user.access_level)
      @available_workshops = TrainingWorkshop.joins(:workshop).where(workshops: {company_id: current_user.company_id}).where.not(date: nil).where.not('date < ?', Date.today) - @my_workshops
    else
      @available_workshops = TrainingWorkshop.joins(:attendees).where(attendees: {user_id: current_user.id, status: 'Invited'}).where.not('date < ?', Date.today)
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
      @workshops = Workshop.all.order(title: :asc)
      if params[:search]
        @workshops = Workshop.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
      elsif params[:filter]
        @workshops = Workshop.joins(:workshop_categories).where(workshop_categories: {category_id: params[:filter].map(&:to_i)}).order(title: :asc)
      end
    # Index for other Users, with visibility limited to programs proposed by their company only
    else
      @workshops = Workshop.where(company_id: current_user.company.id).order(title: :asc)
      if params[:search]
        @workshops = Workshop.where(company_id: current_user.company.id).where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
      elsif params[:filter]
        @workshops = Workshop.joins(:workshop_categories).where(company_id: current_user.company.id, workshop_categories: {category_id: params[:filter].map(&:to_i)}).order(title: :asc)
      end
    end
  end

  def organisation
    # Index with 'search' option and global visibility for SEVEN Users
    index_function(User.all)
    # Index for other Users, with visibility limited to programs proposed by their company only
    @tags = Tag.joins(:company).where(companies: {id: current_user.company_id})
    @tag_categories = TagCategory.where(company_id: current_user.company_id).order(position: :asc)
    if params[:add_tags].present?
      users = User.where(id: params[:add_tags][:users].split(','))
      tags = Tag.where(tag_name: params[:add_tags][:tag].reject(&:blank?))
      users.each do |user|
        tags.each do |tag|
          UserTag.create(user_id: user.id, tag_id: tag.id)
        end
      end
    end
    # if params[:filter].present?
      respond_to do |format|
        format.html {organisation_path}
        format.js
      end
    # end
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
        # tags = Tag.where(tag_name: params[:filter][:tag].reject(&:blank?)).map{|x| x.id}
        tags = Tag.where(tag_name: params[:filter][:tag].reject(&:blank?)).map{|x| x.id}
        if params[:filter][:job] != [""] && params[:filter][:job].present?
          if tags.present?
            @users = (parameter.joins(:user_tags).where(company_id: current_user.company_id, job_title: params[:filter][:job].reject(&:blank?), user_tags: {tag_id: tags}).uniq)
          else
            @users = (parameter.where(company_id: current_user.company_id, job_title: params[:filter][:job].reject(&:blank?)))
          end
        elsif tags.empty?
          @users = parameter.where(company_id: current_user.company.id).order('lastname ASC')
        else
          # @users = (parameter.joins(:user_tags).where(company_id: current_user.company_id, user_tags: {tag_id: tags}).uniq).select{|x| x.tags.map(&:id) & tags == tags}
          @users = (parameter.joins(:user_tags).where(company_id: current_user.company_id, user_tags: {tag_id: tags}).uniq)
        end
        @filter_jobs = params[:filter][:job].reject{|c| c.empty?}
        @filter_tags = params[:filter][:tag].reject{|c| c.empty?}
      elsif params[:order].present?
        if params[:order] == 'tag_category'
          test = Tag.where(tag_category_id: params[:tag_category_id])
          params[:mode] == 'asc' ? @users = User.joins(:tags).merge(Tag.where(tag_category_id: params[:tag_category_id]).order(tag_name: :asc)) : @users = User.joins(:tags).merge(Tag.where(tag_category_id: params[:tag_category_id]).order(tag_name: :desc))
          @users = (@users + User.where(company_id: current_user.company.id).order(lastname: :asc)).uniq
        else
          params[:mode] == 'asc' ? @users = User.where(id: params[:users].split(',')).order(params[:order]) : @users = User.where(id: params[:users].split(',')).order(params[:order]).reverse
        end
      else
        @users = parameter.where(company_id: current_user.company.id).order(id: :asc)
      end
    end
  end
end
