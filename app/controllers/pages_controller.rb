class PagesController < ApplicationController

  # Access dashboard (root)
  def dashboard
    complete_profile_path

    @trainings = Training.where(company: current_user.company)
    @employees_form = User.where(company: current_user.company)
    @types_form = ["Synchronous", "Asynchronous"]

    @recommendations = UserInterest.all

    unless ['Super Admin', 'Account Owner', 'HR'].include?(current_user.access_level)
      @trainings = @trainings.joins(sessions: :attendees).where(attendees: { user_id: current_user.id })
      @recommendations = @recommendations.where(user_id: current_user.id)
    end

    # SEARCH TRAININGS
    if params[:search_trainings].present?
      unless params[:search_trainings][:title].blank?
        @trainings = @trainings.search_trainings("#{params[:search_trainings][:title]}")
      end
      if ['Super Admin', 'Account Owner', 'HR'].include?(current_user.access_level)
        unless params[:search_trainings][:employee].blank?
          selected_employee = User.search_by_name("#{params[:search_trainings][:employee]}").first
          @trainings = @trainings.joins(sessions: :attendees).where(attendees: { user_id: selected_employee.id })
        end
      end
      unless params[:search_trainings][:type].blank?
        @trainings = @trainings.joins(sessions: :workshop).where(workshops: {content_type: params[:search_trainings][:type]})
      end
    end

    # SEARCHING RECOMMENDATIONS
    if params[:search_recommendations].present?
      unless params[:search_recommendations][:title].blank?
        @recommendations = @recommendations.search_recommendations("#{params[:search_recommendations][:title]}")
      end
      if ['Super Admin', 'Account Owner', 'HR'].include?(current_user.access_level)
        unless params[:search_recommendations][:employee].blank?
          selected_employee = User.search_by_name("#{params[:search_recommendations][:employee]}").first
          @recommendations = @recommendations.where(user_id: selected_employee.id)
        end
      end
      unless params[:search_recommendations][:type].blank?
        @recommendations = @recommendations.joins(:content).where(contents: {content_type: params[:search_recommendations][:type]})
      end
    end

    @pending_recommendations = @recommendations.where(recommendation: "Pending")
    @accepted_recommendations = @recommendations.where(recommendation: "Yes")
    @declined_recommendations = @recommendations.where(recommendation: "No")
    @answered_recommendations = @accepted_recommendations + @declined_recommendations

    @current_trainings = @trainings.joins(:sessions).where('date >= ?', Date.today).order(date: :desc).uniq.reverse
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
    if current_user.company_id.present?
      # SEARCHING CONTENTS 
      @contents = Content.where(company_id: current_user.company.id)
      unless params[:reset]
        if params[:search].present? && !params[:search][:title].blank?
          @contents = @contents.search_contents("#{params[:search][:title]}")
          respond_to do |format|
            format.html {catalogue_path}
            format.js
          end
        end
        if params[:select_period].present?
          @start_date = Date.strptime(params[:select_period][:start_date], '%d/%m/%Y')
          @end_date = Date.strptime(params[:select_period][:end_date], '%d/%m/%Y')
          if params[:select_period][:content_ids].present?
            @contents = @contents.where(id: params[:select_period][:content_ids].split(','))
          end
        end
      end
      @contents = @contents.order(updated_at: :desc)
    end
    # if params[:content].present? && params[:content][:categories] != ['']
    #   @contents = @contents.joins(:content_categories).where(content_categories: {category_id: params[:content][:categories].reject{|x| x.empty?}})
    #   if params[:filter_content][:start_date].present? && params[:filter_content][:end_date].present?
    #     @start_date = Date.strptime(params[:filter_content][:start_date], '%d/%m/%Y')
    #     @end_date = Date.strptime(params[:filter_content][:end_date], '%d/%m/%Y')
    #   end
    # end
    
    @sessions = Session.where(content_id: @contents.ids.uniq).where('date >= ? AND date <= ?', @start_date, @end_date)
    respond_to do |format|
      format.html {overview_path}
      format.js
    end
  end

  # Display contents catalogue
  def catalogue
    # @index_title_content = Content.count + 1
    complete_profile
    if current_user.company_id.present?
      # SEARCHING CONTENTS 
      @contents = Content.where(company_id: current_user.company.id).order(updated_at: :asc)
      @folders = Folder.where(company_id: current_user.company.id).order(updated_at: :desc)
      if params[:filter_catalogue].present? && params[:filter_catalogue][:category].reject { |c| c.empty? }.present?
        if params[:filter_catalogue][:searched].present?
          @contents = @contents.search_contents("#{params[:search][:title]}")
          @folders = @folders.search_folders("#{params[:search][:title]}")
        end
        selected_filters = params[:filter_catalogue][:category].reject { |c| c.empty? }
        @contents = @contents.joins(:content_categories).where(company_id: current_user.company_id, content_categories: {category_id: selected_filters}).order(title: :asc).uniq
        @folders = @folders.joins(:folder_categories).where(company_id: current_user.company_id, folder_categories: {category_id: selected_filters}).order(title: :asc).uniq
        @filtered_categories = Category.where(id: selected_filters)
      elsif params[:search].present? && !params[:search][:title].blank?
        if params[:search][:filtered].present?
          selected_filters = params[:filtered].reject { |c| c.empty? }
          @contents = @contents.joins(:content_categories).where(company_id: current_user.company_id, content_categories: {category_id: selected_filters}).uniq
          @folders = @folders.joins(:folder_categories).where(company_id: current_user.company_id, folder_categories: {category_id: selected_filters}).uniq
          @filtered_categories = Category.where(id: selected_filters)
        end
        @contents = @contents.search_contents("#{params[:search][:title]}").order(title: :asc)
        @folders = @folders.search_folders("#{params[:search][:title]}").order(title: :asc)
      end
      respond_to do |format|
        format.html {catalogue_path}
        format.js
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
      params[:csv][:selected_users].present? ? @users = User.where(id: params[:csv][:selected_users].split(',')).order(lastname: :asc).uniq : @users = User.where(company_id: current_user.company_id)
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
      authorize @users
      @tags = Tag.joins(:company).where(companies: {id: current_user.company_id})
      @tag_categories = TagCategory.includes([:tags]).where(company_id: current_user.company_id).order(position: :asc)
      if params[:add_tags].present?
        @selected_users = User.where(id: params[:add_tags][:users].split(','))
        tags = Tag.where(id: params[:tag][:id].reject(&:blank?))
        @selected_users.each do |user|
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
        @unfiltered = 'false'
      else
        @selected_users = []
      end
    end
    respond_to do |format|
      format.html {organisation_path}
      format.js
      format.csv { send_data @users.to_csv(attributes, params[:tag_category][:id], cost, trainings, params[:csv][:start_date], params[:csv][:end_date]), :filename => "Overview - #{params[:csv][:start_date]} to #{params[:csv][:end_date]}.csv" }
    end

    if params[:tag_postion].present?
      tag_cat_selected = TagCategory.find(params[:tag_category_id])
      if params[:tag_postion] == 'left'
        tag_cat_next_left = TagCategory.find_by(position: (tag_cat_selected.position - 1))
        tag_cat_selected.update(position: tag_cat_selected.position - 1)
        tag_cat_next_left.update(position: tag_cat_selected.position + 1)        
      elsif params[:tag_postion] == 'right'
        tag_cat_next_right = TagCategory.find_by(position: (tag_cat_selected.position + 1))
        tag_cat_selected.update(position: tag_cat_selected.position + 1)
        tag_cat_next_right.update(position: tag_cat_selected.position - 1)
      end
      # raise
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
    @users = @users.order(lastname: :asc).page params[:page]
    authorize @users
    params[:search].present? ? @selected_users = params[:search][:book_selected_users] : book_data
    respond_to do |format|
      format.html {book_users_path}
      format.js
    end
  end

  def book_dates
    book_data
    raise "Access denied" unless ['Super Admin', 'Account Owner', 'HR'].include?(current_user.access_level)
  end

  private

  # Filter the users (pages/organisation, pages/book)
  def index_function(parameter)
    if ['Super Admin', 'Account Owner', 'HR'].include?(current_user.access_level)

      @tag_categories = TagCategory.where(company_id: current_user.company_id)
      # If a name is entered in the search bar
      if params[:search].present?
        @users = parameter
        if params[:search][:name] && params[:search][:name] != ' '
          @users = @users.search_by_name("#{params[:search][:name]}") if params[:search][:name].present?
          # @users = @users.where('unaccent(lower(firstname)) LIKE ? OR unaccent(lower(lastname)) LIKE ?', "%#{I18n.transliterate(params[:search][:name].downcase)}%", "%#{I18n.transliterate(params[:search][:name].downcase)}%")
          @search_name = params[:search][:name]
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
      #   raise
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
            @users = parameter.order(lastname: :asc).select(:id, :lastname, :firstname, :email).page params[:page]
            @unfiltered = 'true'
          else
            @users = parameter.where.not(id: params[:filter_user][:selected].split(',')).order(lastname: :asc)
          end
        else
          @users = parameter.order(lastname: :asc).select(:id, :lastname, :firstname, :email).page params[:page]
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
