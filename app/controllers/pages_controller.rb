class PagesController < ApplicationController
  before_action :check_company_presence
  before_action :show_navbar_training
  before_action :show_navbar_home, only: %i[home organisation]

  def home
    @my_interviews = Interview.joins(:campaign)
                              .where(campaigns: {company_id: current_user.company_id}, employee_id: current_user.id, label: 'Employee')
                              .where.not(status: :submitted)
    @my_team_interviews = Interview.joins(:campaign)
                                   .where(campaigns: {company_id: current_user.company_id}, interviewer: current_user, label: ['Manager', 'Crossed'])
                                   .where.not(status: :submitted)
    @my_trainings = Training.where_exists(:attendees, {user: current_user, status: 'Not completed'})
                            .distinct
                            .sort_by{|x| x.sessions.last.available_date.presence || x.sessions.last.date }
    @my_team_trainings = Training.where_exists(:attendees, {user: current_user.employees.ids, status: 'Not completed'})
                                 .distinct
                                 .sort_by{|x| x.sessions.last.available_date.presence || x.sessions.last.date }
  end

  # Display folders/contents catalogue
  def catalogue
    complete_profile

    @contents = policy_scope(Content).where(company_id: current_user.company_id).order(title: :asc)
    @categories = Category.where(company_id: current_user.company_id, kind: :training).order(title: :asc)

    @contents = @contents.search(params.dig(:search, :title)) if params.dig(:search, :title).present?
    @contents = @contents.where(content_type: params.dig(:search, :content_type)) if params.dig(:search, :content_type).present?
    @contents = @contents.joins(:content_categories).where(content_categories: {category_id: params.dig(:search, :selected_categories).split(',')}).distinct if params.dig(:search, :selected_categories).present?

    # TODO : add pagination

    respond_to do |format|
      format.html {catalogue_path}
      format.js
    end
  end

  # Display organisation page
  def organisation
    if params[:csv].present?

      @users =
        if params.dig(:csv, :selected_users).present?
          User.where(id: params.dig(:csv, :selected_users).split(',')).order(lastname: :asc).distinct
        else
          User.where(company_id: current_user.company_id)
        end

      attributes = []
      params[:csv].each do |key, value|
        if !['selected_users', 'cost', 'trainings'].include?(key) && value == '1'
          attributes << key
        end
      end
      cost = params.dig(:csv, :cost)
      trainings = params.dig(:csv, :trainings).to_i > 0
      interviews = params.dig(:csv, :interviews).to_i > 0

    else

      users = policy_scope(User).where(company: current_user.company).order(lastname: :asc)

      @tag_categories = TagCategory.distinct.where(company_id: current_user.company_id).joins(:tags)

      filter_users(users)

    end

    respond_to do |format|
      format.html { organisation_path }
      format.js
      format.csv { send_data @users.to_csv(attributes, params[:tag_category][:id], cost, trainings, params[:csv][:start_date], params[:csv][:end_date]), :filename => "Overview - #{params[:csv][:start_date]} to #{params[:csv][:end_date]}.csv" }
    end
  end

  def create_tag_category_tags
    tag_category_id = params.require(:tag_category_id)
    tag = Tag.create(
      tag_name: params.require(:tag_name),
      company_id: current_user.company_id,
      tag_category_id: tag_category_id)

    render json: tag, status: :ok
  end

  # Display recommendation page
  # def recommendation
  #   index_function(User.where(company_id: current_user.company_id))
  #   authorize @users
  #   if params[:search].present?
  #     @content = Content.find(params[:search][:content_id]) if params[:search][:content_id].present?
  #     @folder = Folder.find(params[:search][:folder_id]) if params[:search][:folder_id].present?
  #     unless params[:search][:status] == 'All'
  #       if @folder.present?
  #         @users = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {folder_id: @folder.id, recommendation: params[:search][:status]})
  #       else
  #         @users = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: params[:search][:status]})
  #       end
  #     end
  #   elsif params[:filter_user].present?
  #     @content = Content.find(params[:filter_user][:content_id]) if params[:filter_user][:content_id].present?
  #     @folder = Folder.find(params[:filter_user][:folder_id]) if params[:filter_user][:folder_id].present?
  #   else
  #     @content = Content.find(params[:content_id]) if params[:content_id].present?
  #     @folder = Folder.find(params[:folder_id]) if params[:folder_id].present?
  #   end
  #   unless @content.nil?
  #     @users_yes = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: 'Yes'})
  #     @users_no = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: 'No'})
  #     @users_pending = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: 'Pending'})
  #   end
  #   unless @folder.nil?
  #     @users_yes = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {folder_id: @folder.id, recommendation: 'Yes'})
  #     @users_no = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {folder_id: @folder.id, recommendation: 'No'})
  #     @users_pending = @users.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {folder_id: @folder.id, recommendation: 'Pending'})
  #   end

  #   @tags = Tag.joins(:company).where(companies: {id: current_user.company_id})
  #   @tag_categories = TagCategory.includes([:tags]).where(company_id: current_user.company_id).order(position: :asc)
  #   respond_to do |format|
  #     format.html {recommendation_path}
  #     format.js
  #   end
  # end

  private

  def check_company_presence
    redirect_to user_path(current_user) unless current_user.company_id.present?
  end

  def filter_users(users)
    search_name = params.dig(:search, :name)

    if search_name.present?
      users = users.search_users(search_name)
    end

    page_index = (params.dig(:search, :page).presence || 1).to_i

    @total_users_count = users.count
    @users = users.page(page_index)
    @any_more = @users.count * page_index < @total_users_count
  end

  # TEMP #
  # TODO cleanup
  # Filter the users (pages/organisation, pages/book)
  # def index_function(parameter)

  #   if UserPolicy.new(current_user, nil).edit?

  #     @tag_categories = TagCategory.where(company_id: current_user.company_id)
  #     # If a name is entered in the search bar
  #     if params[:search].present?
  #       @users = parameter
  #       if params[:search][:name] && params[:search][:name] != ' '
  #         @users = @users.search_by_name("#{params[:search][:name]}") if params[:search][:name].present?
  #         @users = User.where(id: @users.ids).or(User.where(manager_id: @users.ids)) if params[:search][:name].strip =~ /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/
  #         # @users = User.where(id: @users.ids).or(User.where(manager_id: @users.ids)) if params[:search][:staff].to_i == 1
  #         @search_name = params[:search][:name]
  #         # @search_staff = params[:search][:staff]
  #       end
  #       # If the 'clear' button is clicked, return all the employees
  #       @users = @users.reorder(lastname: :asc) if @users.present?
  #     elsif params[:filter_user].present? && (params[:filter_user][:tag].present? && params[:filter_user][:tag].reject{|x|x.empty?} != [])
  #       tags = params[:filter_user][:tag].reject(&:blank?)
  #       if tags.empty?
  #         if params[:filter_user][:selected].present?
  #           @users = parameter.where.not(id: params[:filter_user][:selected].split(',')).order(lastname: :asc)
  #         end
  #       else
  #         if params[:filter_user][:selected].present?
  #           @users = parameter.joins(:user_tags).where(company_id: current_user.company_id).where.not(id: params[:filter_user][:selected].split(','))
  #         else
  #           @users = parameter.joins(:user_tags).where(company_id: current_user.company_id)
  #         end
  #         tags_hash = {}
  #         tags.each do |pair|
  #           key = pair.split(':')[0].to_i
  #           value = pair.split(':')[1].to_i
  #           if tags_hash[key].present?
  #             tags_hash[key] += [value]
  #           else
  #             tags_hash[key] = [value]
  #           end
  #         end
  #         tags_hash.each do |key, value|
  #           @users = @users.where_exists(:tags, id: value)
  #         end
  #         @users = @users.order(lastname: :asc)
  #       end
  #       @filter_tags = Tag.where(id: tags.map{|x| x.split(':')[1]}).map(&:tag_name)
  #     # elsif params[:group].present?
  #     #   @users = User.joins(:tags).merge(Tag.where(tag_category_id: params[:tag_category_id])).group(:tag_name)

  #     # elsif params[:order].present?
  #     #   if params[:order] == 'tag_category'
  #     #     params[:mode] == 'asc' ? @users = User.joins(:tags).merge(Tag.where(tag_category_id: params[:tag_category_id]).order(tag_name: :asc)) : @users = User.joins(:tags).merge(Tag.where(tag_category_id: params[:tag_category_id]).order(tag_name: :desc))
  #     #     @users = (@users + User.where(company_id: current_user.company.id).order(lastname: :asc)).uniq
  #     #   else
  #     #     params[:mode] == 'asc' ? @users = User.where(id: params[:users].split(',')).order(params[:order]) : @users = User.where(id: params[:users].split(',')).order(params[:order]).reverse
  #     #   end
  #     else
  #       if params[:filter_user].present?
  #         if params[:filter_user][:selected].present?
  #           @selected_users = params[:filter_user][:selected]
  #         else
  #           @unfiltered = 'true'
  #         end
  #         if params[:filter_user][:tag].uniq == [""]
  #           # @users = []
  #           @users = parameter.order(lastname: :asc).page params[:page]
  #           @unfiltered = 'true'
  #         else
  #           @users = parameter.where.not(id: params[:filter_user][:selected].split(',')).order(lastname: :asc)
  #         end
  #       else
  #         @users = parameter.order(lastname: :asc).page params[:page]
  #         @unfiltered = 'true'
  #       end

  #     end
  #   end
  #   @unfiltered = 'false' if @unfiltered.nil?
  # end

  # When registering a new account, force the new user to provide some details (firstname, lastname, ...)
  def complete_profile
    redirect_to complete_profile_path unless (current_user.firstname.present? || current_user.lastname.present?)
  end
end
