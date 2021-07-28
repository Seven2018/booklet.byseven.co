class PagesController < ApplicationController

  # Access dashboard (root)
  def dashboard
    complete_profile
    @my_past_sessions = (Session.includes([:content]).joins(:attendees).where(available_date: nil, attendees: {user_id: current_user.id}).where('date < ?', Date.today) + Session.joins(:attendees).where(attendees: {user_id: current_user.id}).where.not(available_date: nil).where('available_date < ?', Date.today)).uniq.sort_by{|x| x.date}
    @my_upcoming_sessions = Session.includes([:content]).joins(:attendees).where(attendees: {user_id: current_user.id}).where('date > ?', Date.today).order(date: :asc)
    @my_current_sessions = (Session.includes([:content]).joins(:attendees).where(date: Date.today, attendees: {user_id: current_user.id}) + Session.joins(:attendees).where(attendees: {user_id: current_user.id}).where.not(available_date: nil).where('date < ?', Date.today).where('available_date >= ?', Date.today)).uniq.sort_by{|x| x.date}
    @all_my_sessions = @my_past_sessions + @my_upcoming_sessions + @my_current_sessions
    @my_recommended_pending = UserInterest.where(user_id: current_user.id, recommendation: 'Pending')
    @my_recommended_answered = UserInterest.where(user_id: current_user.id, recommendation: ['Yes', 'No'])
    if ['Super Admin', 'Account Owner', 'HR'].include?(current_user.access_level)
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

  # Display monthly calendar (pages/dashboard)
  def calendar_month
    @contents = Session.joins(:content).where(contents: {company_id: current_user.company_id})
  end

  # Display weekly calendar (pages/dashboard)
  def calendar_week
    @contents = Session.joins(:content).where(contents: {company_id: current_user.company_id})
  end

  # Display the company Overview (pages/overview)
  def overview
    @contents = Content.where(company_id: current_user.company_id)
    @start_date = Date.today.beginning_of_year
    @end_date = Date.today
    if params[:search].present?
      @contents = @contents.where("unaccent(lower(title)) LIKE ?", "%#{I18n.transliterate(params[:search][:title].downcase)}%")
      if params[:search][:start_date].present? && params[:search][:end_date].present?
        @start_date = Date.strptime(params[:search][:start_date], '%d/%m/%Y')
        @end_date = Date.strptime(params[:search][:end_date], '%d/%m/%Y')
      end
    end
    if params[:content].present? && params[:content][:categories] != ['']
      @contents = @contents.joins(:content_categories).where(content_categories: {category_id: params[:content][:categories].reject{|x| x.empty?}})
      if params[:filter_content][:start_date].present? && params[:filter_content][:end_date].present?
        @start_date = Date.strptime(params[:filter_content][:start_date], '%d/%m/%Y')
        @end_date = Date.strptime(params[:filter_content][:end_date], '%d/%m/%Y')
      end
    end
    if params[:select_period].present?
      @start_date = Date.strptime(params[:select_period][:start_date], '%d/%m/%Y')
      @end_date = Date.strptime(params[:select_period][:end_date], '%d/%m/%Y')
      if params[:select_period][:content_ids].present?
        @contents = @contents.where(id: params[:select_period][:content_ids].split(','))
      end
    end
    @sessions = Session.where(content_id: @contents.ids.uniq).where('date >= ? AND date <= ?', @start_date, @end_date)
    respond_to do |format|
      format.html {overview_path}
      format.js
    end
  end

  # Display contents catalogue
  def catalogue
    complete_profile
    if current_user.company_id.present?
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
  end

  # Manage content_categories (pages/catalogue)
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

  # Display organisation page
  def organisation
    if params[:csv].present?
      params[:csv][:selected_users].present? ? @users = User.where(id: params[:csv][:selected_users]) : @users = User.where(company_id: current_user.company_id)
      attributes = []
      params[:csv].each do |key, value|
        if !['selected_users', 'cost', 'trainings'].include?(key) && value == '1'
          attributes << key
        end
      end
      cost = params[:csv][:cost]
      trainings = params[:csv][:trainings]
    else
      cost, trainings = false, false
      # Index with 'search' option and global visibility for SEVEN Users
      index_function(User.where(company_id: current_user.company_id))
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
            if tag.tag_category.name == 'Job Title'
              user.update(job_title: tag.tag_name)
            end
          end
        end
        @unfiltered = false
        @users = users
      end
    end
    respond_to do |format|
      format.html {organisation_path}
      format.js
      format.csv { send_data @users.to_csv(attributes, params[:tag_category][:id], cost, trainings, params[:csv][:start_date], params[:csv][:end_date]), :filename => "Overview - #{params[:csv][:start_date]} to #{params[:csv][:end_date]}.csv"}
    end
  end

  # Display user info card (not used)
  def organisation_user_card
    @user = User.find(params[:user_id])
    @tag_categories = TagCategory.where(company_id: current_user.company_id).order(position: :asc)
    render partial: "organisation_user_card"
  end

  # Display recommendation page
  def recommendation
    index_function(User.where(company_id: current_user.company_id))
    if params[:search].present?
      @content = Content.find(params[:search][:content_id])
    elsif params[:filter_user].present?
      @content = Content.find(params[:filter_user][:content_id])
    else
      @content = Content.find(params[:content_id])
    end
    @users_yes = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: 'Yes'})
    @users_no = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: 'No'})
    @users_pending = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: 'Pending'})
    @tags = Tag.joins(:company).where(companies: {id: current_user.company_id})
    @tag_categories = TagCategory.includes([:tags]).where(company_id: current_user.company_id).order(position: :asc)
    respond_to do |format|
      format.html {recommendation_path}
      format.js
    end
  end

  # Display book page
  def book
    index_function(User.where(company_id: current_user.company_id))
    if params[:filter_content].present?
      if params[:filter_content][:themes].split(',').uniq.present?
        @contents = Content.joins(:content_categories).where(company_id: current_user.company_id, content_categories: {category_id: params[:filter_content][:themes].split(',')}).where.not(id: params[:filter_content][:selected].split(',')).order(title: :asc).uniq
      else
        @contents = Content.where(company_id: current_user.company_id).where.not(id: params[:filter_content][:selected].split(',')).order(title: :asc)
      end
      @filter = 'content'
      @selected_contents = Content.where(id: params[:filter_content][:selected].split(',')).order(title: :asc)
      @interest_for = @selected_contents.map(&:id)
    elsif params[:filter_user].present?
      @filter = 'user'
      @contents = Content.where(company_id: current_user.company_id).order(title: :asc)
      @interest_for = params[:filter_user][:interest_for].split(',')
      @selected_contents = []
      @selected_filter = params[:filter_user][:tag].reject(&:blank?).join(',') if params[:filter_user][:tag].present?
    elsif params[:confirm].present?
      @selected_contents = Content.where(id: params[:filter_content][:selected].split(',')).order(title: :asc) if params[:filter_content].present?
      @selected_users = User.where(id: params[:filter_user][:selected].split(',')) if params[:filter_user].present?
    else
      @contents = Content.where(company_id: current_user.company_id).order(title: :asc)
      @filter = 'none'
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  # Filter the users (pages/organisation, pages/book)
  def index_function(parameter)
    if ['Super Admin', 'Account Owner', 'HR'].include?(current_user.access_level)
      # If a name is entered in the search bar
      if params[:search].present?
        @users = parameter
        if params[:search][:name] != ' '
          @users = @users.where('lower(firstname) LIKE ? OR lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%", "%#{params[:search][:name].downcase}%")
        end
        # If the 'clear' button is clicked, return all the employees
        @users = @users.order(lastname: :asc).page params[:page] if @users.present?
      elsif params[:filter_user].present? && (params[:filter_user][:tag].present? && params[:filter_user][:tag].reject{|x|x.empty?} != [])
        tags = params[:filter_user][:tag].reject(&:blank?)
        if tags.empty?
          if params[:filter_user][:selected].present?
            @users = parameter.where.not(id: params[:filter_user][:selected].split(',')).order(lastname: :asc)
          end
        else
          if params[:filter_user][:selected].present?
            @users = parameter.joins(:user_tags).where(company_id: current_user.company_id).where.not(id: params[:filter_user][:selected].split(','))
          else
            @users = parameter.joins(:user_tags).where(company_id: current_user.company_id)
          end
          tags.each do |tag|
            @users = @users.where_exists(:tags, tag_name: [tag])
          end
          @users = @users.order(lastname: :asc)
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
            @selected_users = params[:filter_user][:selected]
          else
            @unfiltered = true
          end
          if params[:filter_user][:tag].uniq == [""]
            # @users = []
            @users = parameter.order(lastname: :asc).select(:id, :lastname, :firstname, :email).page params[:page]
            @unfiltered = true
          else
            @users = parameter.where.not(id: params[:filter_user][:selected].split(',')).order(lastname: :asc)
          end
        else
          @users = parameter.order(lastname: :asc).select(:id, :lastname, :firstname, :email).page params[:page]
          @unfiltered = true
        end
      end
      @tag_categories = TagCategory.where(company_id: current_user.company_id)
    end
  end

  # When registering a new account, force the new user to provide some details (firstname, lastname, ...)
  def complete_profile
    redirect_to complete_profile_path unless (current_user.firstname.present? || current_user.lastname.present?)
  end
end
