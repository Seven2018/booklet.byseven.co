class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @my_past_sessions = (Session.includes([:content]).joins(:attendees).where(available_date: nil, attendees: {user_id: current_user.id}).where('date < ?', Date.today) + Session.joins(:attendees).where(attendees: {user_id: current_user.id}).where.not(available_date: nil).where('available_date < ?', Date.today)).uniq.sort_by{|x| x.date}
    @my_upcoming_sessions = Session.includes([:content]).joins(:attendees).where(attendees: {user_id: current_user.id}).where('date > ?', Date.today).order(date: :asc)
    @my_current_sessions = (Session.includes([:content]).joins(:attendees).where(date: Date.today, attendees: {user_id: current_user.id}) + Session.joins(:attendees).where(attendees: {user_id: current_user.id}).where.not(available_date: nil).where('date < ?', Date.today).where('available_date >= ?', Date.today)).uniq.sort_by{|x| x.date}
    @all_my_sessions = @my_past_sessions + @my_upcoming_sessions + @my_current_sessions
    if ['Super Admin', 'Admin', 'HR'].include?(current_user.access_level)
      @past_sessions = (Session.includes([:content]).where(available_date: nil, company_id: current_user.company_id).where('date < ?', Date.today) + Session.where(company_id: current_user.company_id).where.not(available_date: nil).where('available_date < ?', Date.today)).uniq.sort_by{|x| x.date}
      @upcoming_sessions = Session.includes([:content]).where(company_id: current_user.company_id).where('date > ?', Date.today).order(date: :asc)
      @current_sessions = (Session.includes([:content]).where(date: Date.today, company_id: current_user.company_id) + Session.where(company_id: current_user.company_id).where.not(available_date: nil).where('date < ?', Date.today).where('available_date >= ?', Date.today)).uniq.sort_by{|x| x.date}
      @allsessions = @past_sessions + @upcoming_sessions + @current_sessions
    end
    if params[:date].present?
      @tab = params[:tab]
      @date = params[:date].to_date
      respond_to do |format|
        format.js
      end
    end
  end

  def calendar_month
    @contents = Session.joins(:content).where(contents: {company_id: current_user.company_id})
  end

  def calendar_week
    @contents = Session.joins(:content).where(contents: {company_id: current_user.company_id})
  end

  def catalogue
    if params[:filter].present?
      if params[:filter][:themes].split(',').uniq.present?
        @contents = Content.joins(:content_categories).where(company_id: current_user.company_id, content_categories: {category_id: params[:filter][:themes].split(',')}).order(title: :asc).uniq
      else
        @contents = Content.where(company_id: current_user.company_id).order(title: :asc)
      end
      respond_to do |format|
        format.html {catalogue_path}
        format.js
      end
    # Index with 'search' option and global visibility for SEVEN Users
    #elsif current_user.access_level == 'Super Admin'
    #  @contents = Content.all.order(title: :asc)
    #  if params[:search].present?
    #   @contents = Content.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
    #    respond_to do |format|
    #      format.html {catalogue_path}
    #      format.js
    #    end
    #  end
    # Index for other Users, with visibility limited to programs proposed by their company only
    else
      @contents = Content.where(company_id: current_user.company.id).order(title: :asc)
      if params[:search].present?
        @contents = Content.where(company_id: current_user.company.id).where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc) if params[:search] != ' '
        respond_to do |format|
          format.html {catalogue_path}
          format.js
        end
      end
    end
  end

  def catalogue_content_link_category
    skip_authorization
    if params[:new_category].present?
      Category.create(company_id: current_user.company_id, title: params[:new_category][:title])
      @content = Content.find(params[:new_category][:content_id])
      @modal = 'true'
    elsif params[:delete].present?
      Category.find(params[:category_id]).destroy
      @content = Content.find(params[:content_id])
      @modal = 'true'
    elsif params[:add_categories].present?
      @action = params[:add_categories][:page]
      @content = Content.find(params[:add_categories][:content_id])
      ids = params[:content][:categories].reject{|x| x.empty?}
      ids.each do |category_id|
        unless ContentCategory.find_by(content_id: @content.id, category_id: category_id).present?
          ContentCategory.create(content_id: @content.id, category_id: category_id)
        end
      end
      ContentCategory.where(content_id: @content.id).where.not(category_id: ids).each do |content_category|
        content_category.destroy
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def catalogue_filter_add_category
    skip_authorization
    params[:categories].present? ? @filtered_themes = Category.where(id: (params[:categories].split(',') + params[:category_id].split())) : @filtered_themes = Category.where(id: params[:category_id])
    respond_to do |format|
      format.js
    end
  end

  def organisation
    # Index with 'search' option and global visibility for SEVEN Users
    index_function(User.where(company_id: current_user.company_id).select(:id, :lastname, :firstname, :email))
    # Index for other Users, with visibility limited to programs proposed by their company only
    @tags = Tag.joins(:company).where(companies: {id: current_user.company_id})
    @tag_categories = TagCategory.includes([:tags]).where(company_id: current_user.company_id).order(position: :asc)
    if params[:add_tags].present?
      users = User.where(id: params[:add_tags][:users].split(','))
      tags = Tag.where(id: params[:tag][:id].reject(&:blank?))
      users.each do |user|
        tags.each do |tag|
          current = UserTag.where(user_id: user.id, tag_category_id: tag.tag_category_id).first
          if current.present?
            current.destroy
          end
          UserTag.create(user_id: user.id, tag_id: tag.id, tag_category_id: tag.tag_category_id)
        end
      end
    end
    respond_to do |format|
      format.html {organisation_path}
      format.js
    end
  end

  def organisation_user_card
    @user = User.find(params[:user_id])
    @tag_categories = TagCategory.where(company_id: current_user.company_id).order(position: :asc)
    render partial: "organisation_user_card"
  end

  def book
    index_function(User.where(company_id: current_user.company_id))
    if params[:filter_content].present?
      if params[:filter_content][:themes].split(',').uniq.present?
        @contents = Content.joins(:content_categories).where(company_id: current_user.company_id, content_categories: {category_id: params[:filter_content][:themes].split(',')}).where.not(id: params[:filter_content][:selected].split(',')).order(title: :asc).uniq
      else
        @contents = Content.where(company_id: current_user.company_id).where.not(id: params[:filter_content][:selected].split(',')).order(title: :asc)
      end
      @filter = 'content'
      @selected_contents = Content.where(id: params[:filter_content][:selected].split(',')).order(title: :asc) if params[:filter_content].present?
    elsif params[:filter_user].present?
      @filter = 'user'
      @contents = Content.where(company_id: current_user.company_id).order(title: :asc)
      @interest_for = params[:filter_user][:interest_for].split(',')
      @selected_contents = []
      @selected_filter = params[:filter_user][:tag].reject(&:blank?).join(',')
    elsif params[:confirm].present?
      @selected_contents = Content.where(id: params[:filter_content][:selected].split(',')).order(title: :asc) if params[:filter_content].present?
    else
      @contents = Content.where(company_id: current_user.company_id).order(title: :asc)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def index_function(parameter)
    if ['Super Admin', 'HR'].include?(current_user.access_level)
      if params[:search].present?
        @users = parameter.order(id: :asc)
        if params[:search][:name] != ' '
          @users = (@users.where('lower(firstname) LIKE ?', "%#{params[:search][:name].downcase}%") + @users.where('lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%"))
        end
        @users = @users.sort_by{ |user| user.lastname } if @users.present?
      elsif params[:filter_user].present? && (params[:filter_user][:tag].present? && params[:filter_user][:tag].reject{|x|x.empty?} != [])
        # tags = Tag.where(tag_name: params[:filter_user][:tag].reject(&:blank?)).map{|x| x.id}
        tags = Tag.where(tag_name: params[:filter_user][:tag].reject(&:blank?))
        tags_hash = {}
        tags.each do |tag|
          if tags_hash[tag.tag_category_id].present?
            tags_hash[tag.tag_category_id] << tag
          else
            tags_hash[tag.tag_category_id] = [tag]
          end
        end
        if tags.empty?
          if params[:filter_user][:selected].present?
            @users = parameter.where.not(id: params[:filter_user][:selected].split(',')).order(lastname: :asc)
          else
            @users = parameter.order(lastname: :asc)
          end
        else
          if params[:filter_user][:selected].present?
            @users = parameter.joins(:user_tags).where(company_id: current_user.company_id).where.not(id: params[:filter_user][:selected].split(',')).order(lastname: :asc)
          else
            @users = parameter.joins(:user_tags).where(company_id: current_user.company_id).order(lastname: :asc)
          end
          tags_hash.each do |key, value|
            @users = @users.select{|x| (x.tags & value).present?}.uniq
          end
          @users = @users.uniq
        end
        @filter_tags = params[:filter_user][:tag].reject{|c| c.empty?}
      elsif params[:order].present?
        if params[:order] == 'tag_category'
          params[:mode] == 'asc' ? @users = User.joins(:tags).merge(Tag.where(tag_category_id: params[:tag_category_id]).order(tag_name: :asc)) : @users = User.joins(:tags).merge(Tag.where(tag_category_id: params[:tag_category_id]).order(tag_name: :desc))
          @users = (@users + User.where(company_id: current_user.company.id).order(lastname: :asc)).uniq
        else
          params[:mode] == 'asc' ? @users = User.where(id: params[:users].split(',')).order(params[:order]) : @users = User.where(id: params[:users].split(',')).order(params[:order]).reverse
        end
      else
        if params[:filter_user].present?
          if params[:filter_user][:selected].present?
            @users = parameter.where.not(id: params[:filter_user][:selected].split(',')).order(lastname: :asc)
          else
            @users = parameter.order(lastname: :asc)
          end
        else
          @users = parameter.order(lastname: :asc)
        end
      end
      @tag_categories = TagCategory.where(company_id: current_user.company_id)
    end
  end
end
