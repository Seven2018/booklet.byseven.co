class PagesController < ApplicationController
  before_action :show_navbar_admin, only: :organisation
  before_action :show_navbar_training

  def home
    @my_interviews = Interview.joins(:campaign).where(campaigns: {company_id: current_user.company_id}, employee_id: current_user.id, completed: false)
    @my_team_interviews = Interview.joins(:campaign).where(campaigns: {company_id: current_user.company_id, owner_id: current_user.id}, label: ['Manager', 'Crossed', 'Simple'], completed: false)
  end

  # Display the company Overview (pages/overview)
  def overview
    @start_date = Date.today.beginning_of_year
    @end_date = Date.today

    @trainings = Training.where(company_id: current_user.company_id)
    # @trainings = Training.where(id: @trainings.pluck(:id))

    # SEARCHING CONTENTS
    unless params[:reset]
      if params[:search].present?
        unless params[:search][:title].blank?
          @trainings = @trainings.search_trainings("#{params[:search][:title]}")
        end
        if params[:search][:start_date].present?
          @start_date = Date.strptime(params[:search][:start_date], '%d/%m/%Y')
          @end_date = Date.strptime(params[:search][:end_date], '%d/%m/%Y')
          @trainings = @trainings.joins(:sessions).where('sessions.date >= ? AND date <= ?', @start_date, @end_date).uniq
        end
      end
    end

    @sessions = @trainings.map{|x| x.sessions}.flatten
    attendees = Attendee.joins(:session).where(sessions: { training: @trainings})
    @users = User.where(attendees: attendees)

    respond_to do |format|
      format.html {overview_path}
      format.js
    end

  end

  # Display folders/contents catalogue
  def catalogue
    complete_profile

    @contents = Content.where(company_id: current_user.company_id).order(title: :asc)
    @categories = Category.where(company_id: current_user.company_id).order(title: :asc)

    @contents = @contents.search_contents(params.dig(:search, :title)) if params.dig(:search, :title).present?
    @contents = @contents.where(content_type: params.dig(:search, :content_type)) if params.dig(:search, :content_type).present?
    @contents = @contents.joins(:content_categories).where(content_categories: {category_id: params.dig(:search, :selected_categories).split(',')}).distinct if params.dig(:search, :selected_categories).present?

    # TO DO : add pagination

    respond_to do |format|
      format.html {catalogue_path}
      format.js
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
    users = policy_scope(User).where(company: current_user.company).order(lastname: :asc)

    @tag_categories = TagCategory.includes([:tags]).where(company_id: current_user.company_id).order(position: :asc)

    filter_users(users)

    respond_to do |format|
      format.html {organisation_path}
      format.js
      format.csv { send_data @users.to_csv(attributes, params[:tag_category][:id], cost, trainings, interviews, params[:csv][:start_date], params[:csv][:end_date]), :filename => "Overview - #{params[:csv][:start_date]} to #{params[:csv][:end_date]}.csv" }
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
    authorize @users
    if params[:search].present?
      @content = Content.find(params[:search][:content_id]) if params[:search][:content_id].present?
      @folder = Folder.find(params[:search][:folder_id]) if params[:search][:folder_id].present?
      unless params[:search][:status] == 'All'
        if @folder.present?
          @users = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {folder_id: @folder.id, recommendation: params[:search][:status]})
        else
          @users = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: params[:search][:status]})
        end
      end
    elsif params[:filter_user].present?
      @content = Content.find(params[:filter_user][:content_id]) if params[:filter_user][:content_id].present?
      @folder = Folder.find(params[:filter_user][:folder_id]) if params[:filter_user][:folder_id].present?
    else
      @content = Content.find(params[:content_id]) if params[:content_id].present?
      @folder = Folder.find(params[:folder_id]) if params[:folder_id].present?
    end
    unless @content.nil?
      @users_yes = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: 'Yes'})
      @users_no = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: 'No'})
      @users_pending = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: 'Pending'})
    end
    unless @folder.nil?
      @users_yes = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {folder_id: @folder.id, recommendation: 'Yes'})
      @users_no = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {folder_id: @folder.id, recommendation: 'No'})
      @users_pending = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {folder_id: @folder.id, recommendation: 'Pending'})
    end

    @tags = Tag.joins(:company).where(companies: {id: current_user.company_id})
    @tag_categories = TagCategory.includes([:tags]).where(company_id: current_user.company_id).order(position: :asc)
    respond_to do |format|
      format.html {recommendation_path}
      format.js
    end
  end

  # Display book pages

  def book_contents
    @folders = Folder.where(company_id: current_user.company_id).order(title: :asc)
    @contents = Content.where(company_id: current_user.company_id).order(title: :asc)
    if params[:search].present? && !params[:search][:title].blank?
      @contents = @contents.search_contents("#{params[:search][:title]}").order(title: :asc)
      @folders = @folders.search_folders("#{params[:search][:title]}").order(title: :asc)
    end
    if params[:search].present?
      @selected_folder = params[:search][:book_selected_folder]
      @selected_content = params[:search][:book_selected_content]
    end
    authorize @contents
    authorize @folders
    book_data
    respond_to do |format|
      format.html {book_contents_path}
      format.js
    end
  end

  def book_users
    @users = User.where(company_id: current_user.company_id)
    if params[:search].present? && !params[:search][:title].blank?
      @users = @users.search_by_name("#{params[:search][:title]}")
      @filter = 'true'
    else
      @filter = 'false'
    end
    authorize @users
    @users = @users.order(lastname: :asc).page params[:page]
    params[:search].present? ? @selected_users = params[:search][:book_selected_users] : book_data
    respond_to do |format|
      format.html {book_users_path}
      format.js
    end
  end

  def book_dates
    book_data
    raise "Access denied" unless current_user.hr_or_above?
  end

  private

  def filter_users(users)
    search_name = params.dig(:search, :name)

    # if (params.dig(:filter_tags) && params.dig(:filter_tags, :tag)).present? || params.dig(:search, :tags).present?
    #   selected_tags = params.dig(:search, :tags).present? ? params.dig(:search, :tags).split(',') : params.dig(:filter_tags, :tag).map{|x| x.split(':').last.to_i}
    #   users = User.where(company_id: current_user.company_id).where_exists(:user_tags, tag_id: selected_tags)
    #   @filtered_by_tags = 'true'
    # end

    if search_name.present?
      users = users.search_users(search_name)
      @filtered = true
    else
      @filtered_by_tags = 'false'
      @filtered = false
    end

    page_index = params.dig(:search, :page).present? ? params.dig(:search, :page).to_i : 1
    page_index = params[:page] if params[:page].present?

    @total_users_count = users.count
    @users = users.page(page_index)
    @any_more = @users.count * page_index < @total_users_count
  end

  # TEMP #
  # Filter the users (pages/organisation, pages/book)
  def index_function(parameter)
    if current_user.hr_or_above?

      @tag_categories = TagCategory.where(company_id: current_user.company_id)
      # If a name is entered in the search bar
      if params[:search].present?
        @users = parameter
        if params[:search][:name] && params[:search][:name] != ' '
          @users = @users.search_by_name("#{params[:search][:name]}") if params[:search][:name].present?
          @users = User.where(id: @users.ids).or(User.where(manager_id: @users.ids)) if params[:search][:name].strip =~ /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/
          # @users = User.where(id: @users.ids).or(User.where(manager_id: @users.ids)) if params[:search][:staff].to_i == 1
          @search_name = params[:search][:name]
          # @search_staff = params[:search][:staff]
        end
        # If the 'clear' button is clicked, return all the employees
        @users = @users.reorder(lastname: :asc) if @users.present?
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
          tags_hash = {}
          tags.each do |pair|
            key = pair.split(':')[0].to_i
            value = pair.split(':')[1].to_i
            if tags_hash[key].present?
              tags_hash[key] += [value]
            else
              tags_hash[key] = [value]
            end
          end
          tags_hash.each do |key, value|
            @users = @users.where_exists(:tags, id: value)
          end
          @users = @users.order(lastname: :asc)
        end
        @filter_tags = Tag.where(id: tags.map{|x| x.split(':')[1]}).map(&:tag_name)
      # elsif params[:group].present?
      #   @users = User.joins(:tags).merge(Tag.where(tag_category_id: params[:tag_category_id])).group(:tag_name)

      # elsif params[:order].present?
      #   if params[:order] == 'tag_category'
      #     params[:mode] == 'asc' ? @users = User.joins(:tags).merge(Tag.where(tag_category_id: params[:tag_category_id]).order(tag_name: :asc)) : @users = User.joins(:tags).merge(Tag.where(tag_category_id: params[:tag_category_id]).order(tag_name: :desc))
      #     @users = (@users + User.where(company_id: current_user.company.id).order(lastname: :asc)).uniq
      #   else
      #     params[:mode] == 'asc' ? @users = User.where(id: params[:users].split(',')).order(params[:order]) : @users = User.where(id: params[:users].split(',')).order(params[:order]).reverse
      #   end
      else
        if params[:filter_user].present?
          if params[:filter_user][:selected].present?
            @selected_users = params[:filter_user][:selected]
          else
            @unfiltered = 'true'
          end
          if params[:filter_user][:tag].uniq == [""]
            # @users = []
            @users = parameter.order(lastname: :asc).page params[:page]
            @unfiltered = 'true'
          else
            @users = parameter.where.not(id: params[:filter_user][:selected].split(',')).order(lastname: :asc)
          end
        else
          @users = parameter.order(lastname: :asc).page params[:page]
          @unfiltered = 'true'
        end

      end
    end
    @unfiltered = 'false' if @unfiltered.nil?
  end

  # When registering a new account, force the new user to provide some details (firstname, lastname, ...)
  def complete_profile
    redirect_to complete_profile_path unless (current_user.firstname.present? || current_user.lastname.present?)
  end

  def book_data
    if params[:book].present?
      @selected_folder = params[:book][:selected_folder]
      @selected_content = params[:book][:selected_content]
      @selected_users = params[:book][:selected_users]
    end
  end
end
