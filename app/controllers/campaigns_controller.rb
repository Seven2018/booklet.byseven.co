class CampaignsController < ApplicationController
  before_action :set_campaign, only: %i[show overview update send_notification_email destroy toggle_tag remove_company_tag search_tags index_line]
  before_action :show_navbar_campaign

  skip_forgery_protection
  skip_after_action :verify_authorized, only: [
    :destroy,
    :data_show
  ]

  def index
    policy_scope(Campaign)
  end

  def list
    campaigns = Campaign.where(company: current_user.company)
    campaigns = campaigns.search_campaigns(params[:title]) if params[:title].present?
    campaigns = campaigns.where_not_exists(:interviews, locked_at: nil) if params[:status].present? && params[:status] == 'completed'
    campaigns = campaigns.where_exists(:interviews, locked_at: nil) if params[:status].present? && params[:status] == 'current'
    campaigns = campaigns.filter_by_tag_ids(params[:tags]) if params[:tags].present?
    campaigns = campaigns.order(created_at: :desc)


    page = params[:page] && params[:page][:number] ? params[:page][:number] : 1
    size = params[:page] && params[:page][:size] ? params[:page][:size] : SIZE_PAGE_INDEX
    campaigns = campaigns.page(page).per(size)

    authorize campaigns

    render json: campaigns, meta: pagination_dict(campaigns)
  end

  def show
    cancel_cache

    authorize @campaign

    @campaign = @campaign.decorate
    campaign_id = @campaign.id

    @employees = User.where_exists(:interviews, campaign_id: campaign_id, interviewer: current_user).order(lastname: :asc)

    filter_employees(campaign_id)

    respond_to do |format|
      format.html
      format.js
      format.json {
        render json: @campaign, status: :ok, serializer: CampaignSerializer
      }
    end
  end

  def data_show
    campaign = Campaign.find(params.require(:id))
    page = params[:page] && params[:page][:number] ? params[:page][:number] : 1
    size = params[:page] && params[:page][:size] ? params[:page][:size] : SIZE_PAGE_INDEX

    employees = campaign.employees.distinct
    employees = User.where(id: employees.ids).search_users(params[:text]) if params[:text].present?
    employees = check_user_categories(employees) if params[:userCategories].present?

    interviews = campaign.interviews.where(employee_id: employees.ids)
    interviews = interviews.where(status: params[:status]) if params[:status].present?
    interviews = interviews.where.not(id: interviews.ids_without_employee_interview)
    interviews = filter_tag_by_interview_set(interviews) if params[:tags].present?

    employee_interviews = interviews.employee_label
    employee_interviews = employee_interviews.page(page).per(size)
    interview_sets = serialize_interview_set(employee_interviews.pluck(:employee_id), interviews)
    # interview_sets = interview_sets.select {|interview_set| interview_set[:status] == params[:status].to_sym } if params[:status].present?

    render json: {
      set_interviews: interview_sets,
      meta: pagination_dict(employee_interviews)
    }, status: :ok
  end

  def overview
    cancel_cache

    authorize @campaign

    @campaign = @campaign.decorate
    campaign_id = @campaign.id

    @tag_categories = TagCategory.where(company_id: current_user.company_id).order(position: :asc)

    employees_ids = @campaign.employees.uniq.map(&:id)
    @employees = User.where(id: employees_ids).order(lastname: :asc)

    filter_employees(campaign_id)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    authorize @campaign

    @campaign.update(campaign_params)

    head :ok
  end

  def destroy
    authorize @campaign

    @id = @campaign.id
    @campaign.destroy

    respond_to do |format|
      format.js
      format.json {head :ok}
    end
  end

  def my_interviews
    @campaigns = Campaign.where(company: current_user.company).order(created_at: :desc).where \
      id: Interview.where(employee: current_user).distinct.pluck(:campaign_id)
    authorize @campaigns

    ongoing_interviews = Interview.where(employee: current_user, label: 'Employee')
                                 .select{|x| !x.archived_for['Employee']}
    archived_interviews = Interview.where(employee: current_user, label: 'Employee')
                                   .select{|x| x.archived_for['Employee']}

    @ongoing_campaigns = @campaigns.where_exists(:interviews, id: ongoing_interviews.map(&:id))
    @archived_campaigns = @campaigns.where_exists(:interviews, id: archived_interviews.map(&:id))
    @todo_campaigns = @ongoing_campaigns.where_not_exists(:interviews, employee: current_user,
                                                                       label: 'Employee',
                                                                       status: 'submitted')

    @active_tab = params.dig(:status).presence || 'ongoing'

    @campaigns =
      if @active_tab == 'archived'
        @archived_campaigns
      else
        @ongoing_campaigns
      end

    @campaigns = CampaignDecorator.decorate_collection @campaigns

    respond_to do |format|
      format.html
      format.js
    end
  end

  def my_interviews_list
    @campaigns = Campaign.where(company: current_user.company).order(created_at: :desc).where \
      id: Interview.where(employee: current_user).distinct.pluck(:campaign_id)
    authorize @campaigns

    ongoing_interviews = Interview.where(employee: current_user, label: 'Employee')
                                  .select{|x| !x.archived_for['Employee']}
    archived_interviews = Interview.where(employee: current_user, label: 'Employee')
                                   .select{|x| x.archived_for['Employee']}

    @ongoing_campaigns = @campaigns.where_exists(:interviews, id: ongoing_interviews.map(&:id))
    @archived_campaigns = @campaigns.where_exists(:interviews, id: archived_interviews.map(&:id))

    render json: {
      current_campaigns: ActiveModelSerializers::SerializableResource.new(
        @ongoing_campaigns, {each_serializer: CampaignSerializer, for_user: current_user}
      ),
      archived_campaigns: ActiveModelSerializers::SerializableResource.new(
        @archived_campaigns, {each_serializer: CampaignSerializer, for_user: current_user}
      ),
    }, status: :ok
  end

  def my_team_interviews
    @campaigns = Campaign.where(company: current_user.company).order(created_at: :desc)
    @campaigns = @campaigns.where_exists(:interviews, interviewer: current_user)
    authorize @campaigns

    ongoing_interviews = Interview.where(interviewer: current_user)
                                  .select{|x| !x.archived_for['Manager'].present?}
    archived_interviews = Interview.where(interviewer: current_user)
                                   .select{|x| x.archived_for['Manager'].present?}

    @ongoing_campaigns = @campaigns.where_exists(:interviews, id: ongoing_interviews.map(&:id)).distinct
    @archived_campaigns = @campaigns.where_exists(:interviews, id: archived_interviews.map(&:id)).distinct
    @todo_campaigns = @ongoing_campaigns.where_not_exists(:interviews, interviewer: current_user,
                                                                       label: ['Manager', 'Crossed'],
                                                                       status: 'submitted')
    @active_tab = params.dig(:status).presence || 'ongoing'

    @campaigns =
      if params.dig(:status) == 'archived'
        @archived_campaigns
      else
        @ongoing_campaigns
      end

    @campaigns = @campaigns&.sort { |x| x.deadline }&.reverse

    respond_to do |format|
      format.html
      format.js
    end
  end


  def my_team_interviews_list
    @campaigns = Campaign
                   .where(company: current_user.company)
                   .where_exists(:interviews, interviewer: current_user).order(created_at: :desc)
    authorize @campaigns

    ongoing_interviews = Interview.where(interviewer: current_user)
                                  .select{|x| !x.archived_for['Manager'].present?}
    archived_interviews = Interview.where(interviewer: current_user)
                                   .select{|x| x.archived_for['Manager'].present?}

    @ongoing_campaigns = @campaigns.where_exists(:interviews, id: ongoing_interviews.map(&:id)).distinct
    @archived_campaigns = @campaigns.where_exists(:interviews, id: archived_interviews.map(&:id)).distinct

    render json: {
      current_campaigns: ActiveModelSerializers::SerializableResource.new(
        @ongoing_campaigns, {each_serializer: CampaignSerializer, for_user: current_user, schema: 'manager'}
      ),
      archived_campaigns: ActiveModelSerializers::SerializableResource.new(
        @archived_campaigns, {each_serializer: CampaignSerializer, for_user: current_user, schema: 'manager'}
      ),
    }, status: :ok
  end

  def campaign_edit_date
    @campaign = Campaign.find(params.dig(:edit_date, :campaign_id))
    authorize @campaign

    @campaign.interviews.where(employee_id: params.dig(:edit_date, :employee_id)).update_all date: params.dig(:edit_date, :date)

    head :no_content
  end


  ##########################
  ## EMAILS NOTIFICATIONS ##
  ##########################

  def send_notification_email
    authorize @campaign
    interviewee = User.find_by(id: params[:user_id])

    if interviewee.present?
      interview = Interview.find_by(campaign: @campaign, employee: interviewee, label: 'Employee')
      interviewer = interview.interviewer

      if params[:email_type] == 'invite'
        invitation_email(interviewer, interviewee, interview)
      else
        reminder_email(interviewer, interviewee, interview)
      end

    else
      @campaign.interviews.where(label: 'Employee').each do |interview|
        params[:email_type] == 'invite' ? invitation_email(interview.interviewer, interview.employee, interview) : reminder_email(interview.interviewer, interview.employee, interview)
      end

      @campaign.interviewers.uniq.each do |interviewer|
        params[:email_type] == 'invite' ? invitation_email_interviewer(interviewer, @campaign) : reminder_email_interviewer(interviewer, @campaign)
      end
    end

    @email_type = params[:email_type] == 'invite' ? 'Invitation' : 'Reminder'

    respond_to do |format|
      format.js
      format.json {
        head :ok
      }
    end
  end

  ###########################
  ## CATEGORIES MANAGEMENT ##
  ###########################

  def toggle_tag
    authorize @campaign
    tag = params.require(:tag)
    category = Category.find_by(company_id: current_user.company_id, title: tag, kind: :interview)

    if category.nil?
      def_group_category = current_user.company.group_categories.default_group_for(:interview)
      new_category = Category.create(
        company_id: current_user.company_id,
        title: tag,
        kind: :interview,
        group_category: def_group_category)
      @campaign.categories << new_category
    else
      if @campaign.categories.exists?(category.id)
        @campaign.categories.delete(category)
      else
        @campaign.categories << category
      end
    end

    @displayed_tags = Category.where(company_id: current_user.company_id, kind: :interview)
                              .where_exists(:campaigns)
                              .order(title: :asc)

    respond_to do |format|
      format.html {
        render partial: 'campaigns/index/index_campaigns_displayed_tags', locals: { displayed_tags: @displayed_tags }
      }
      format.json {head :ok}
    end
  end

  def remove_company_tag
    authorize @campaign
    tag = params.require(:tag)

    Category.where(company_id: current_user.company_id, title: tag, kind: :interview).destroy_all

    @displayed_tags = Category.where(company_id: current_user.company_id, kind: :interview)
                              .where_exists(:campaigns)
                              .order(title: :asc)

    render partial: 'campaigns/index/index_campaigns_displayed_tags', locals: { displayed_tags: @displayed_tags }
  end

  def search_tags
    authorize @campaign
    input = params[:input]
    black_tags = Campaign.find(@campaign.id).categories.pluck(:title)
    tags = Category
             .where(company_id: current_user.company_id, kind: :interview)
             .where.not(title: black_tags)
             .where('lower(title) LIKE ?', "%#{input.downcase}%")
             .order(title: :asc)
             .pluck(:title)

    render json: tags, root: 'categories', status: :ok
  end

  def index_line
    skip_authorization

    @campaign = @campaign.decorate

    respond_to do |format|
      format.js
    end
  end


  ##############
  ## CALENDAR ##
  ##############

  def redirect_calendar
    skip_authorization

    client = Signet::OAuth2::Client.new(client_options)
    client.update!(state: Base64.encode64("instance_id:#{params[:instance_id]},user_id:#{params[:user_id]},mode:#{params[:mode]}"))
    redirect_to client.authorization_uri.to_s
  end

  def update_calendar
    skip_authorization
    # Gets clearance from OAuth
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]
    # client.update!(:additional_parameters => {"access_type" => "offline"})
    client.update!(client.fetch_access_token!)
    # Initiliaze GoogleCalendar
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    state = Base64.decode64(params[:state]).to_h
    mode = state['mode']
    user = User.find(state['user_id'])
    instance = mode == 'campaign' ? Campaign.find(state['instance_id']) : Interview.find(state['instance_id'])

    return if user != current_user

    date = calendar_create_event(instance, user, service).strftime('%Y/%m/%d')

    redirect_to "https://calendar.google.com/calendar/u/0/r/week/#{date}"
  end

  ##############

  private

  def filter_employees(campaign_id)
    search_name = params.dig(:search, :name)
    search_interviewer = params.dig(:search, :interviewer)
    search_tags = params.dig(:search, :tag_categories)&.permit!&.to_hash&.compact&.values
    search_completion = params.dig(:search, :completion)&.downcase&.gsub(' ', '_')

    @employees = @employees.search_users(search_name) if search_name.present?

    @employees = @employees.where_exists(:interviews, campaign_id: campaign_id, interviewer_id: search_interviewer) \
      if search_interviewer.present?

    if search_tags.present?
      search_tags.each do |tag|
        @employees = @employees.where_exists(:tags, id: tag)
      end
    end

    if ['not_started', 'in_progress', 'completed'].include?(search_completion)
      employees_ids = @employees.select{|x| @campaign.completion_status(x) == search_completion}.map(&:id)
      @employees = @employees.where(id: employees_ids)
    end

    page_index = (params.dig(:search, :page).presence || 1).to_i
    @total_employees_count = @employees.count
    @employees = @employees.page(page_index)
    @any_more = @employees.count * page_index < @total_employees_count
  end

  ############################
  ## GOOGLE::APIS::CALENDAR ##
  ############################

  def client_options
    {
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: "#{request.base_url}/campaigns/update_calendar"
    }
  end

  def calendar_create_event(instance, user, service)
    if instance.class == Campaign
      date = instance.deadline.to_datetime
      day, month, year = date.day, date.month, date.year
      start_time = date.change(day: day, month: month, year: year, hour: 7)
      end_time = date.change(day: day, month: month, year: year, hour: 16)
      summary_text = "Last day of the #{instance.title} campaign on Booklet !"
    else
      date = instance.date
      day, month, year = date.day, date.month, date.year
      start_time = instance.starts_at.change(day: day, month: month, year: year)
      end_time = instance.ends_at.change(day: day, month: month, year: year)
      summary_text = "#{instance.campaign.title} - #{instance.label}#{ (' - ' + instance.employee.fullname) if user == instance.interviewer }"
    end

    event = Google::Apis::CalendarV3::Event.new({
              start: {
                date_time: start_time.rfc3339,
                time_zone: 'Europe/Paris',
              },
              end: {
                date_time: end_time.rfc3339,
                time_zone: 'Europe/Paris',
              },
              summary: summary_text
            })

    if instance.class == Campaign
      event.id = instance.calendar_uuid
    else
      event.id = instance.calendar_uuid.presence || SecureRandom.hex(32)
      instance.update calendar_uuid: event.id unless instance.calendar_uuid.present?
    end

    begin
      service.update_event('primary', event.id, event)
    rescue
      service.insert_event('primary', event)
    end

    return date
  end

  def calendar_delete_event(instance, user, service)
    begin
      return if instance.calendar_uuid.nil?
      service.delete_event(user.email, instance.calendar_uuid)
    rescue
    end
  end


  ##########################
  ## EMAILS NOTIFICATIONS ##
  ##########################

  def invitation_email(interviewer, interviewee, interview)
    CampaignMailer.with(user: interviewee)
                  .invite_employee(interviewer, interviewee, interview)
                  .deliver_later
  end

  def invitation_email_interviewer(interviewer, campaign)
    CampaignMailer.with(user: interviewer)
                  .invite_interviewer(interviewer, campaign)
                  .deliver_later
  end

  def reminder_email(interviewer, interviewee, interview)
    CampaignMailer.with(user: interviewee)
                  .interview_reminder(interviewer, interviewee, interview)
                  .deliver_later
  end

  def reminder_email_interviewer(interviewer, campaign)
    CampaignMailer.with(user: interviewer)
                  .campaign_interviewer_reminder(interviewer, campaign)
                  .deliver_later
  end

  ##########################

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def campaign_data
    if params[:campaign].present?
      @selected_template = params[:campaign][:selected_template]
      @selected_users = params[:campaign][:selected_users]
    end
  end

  def campaign_params
    params.require(:campaign).permit(:deadline)
  end

  def serialize_interview_set(employee_ids, interviews)
    employee_ids.map do |employee_id|
      if params[:from].present? && params[:from] == 'overview'
        manager_interview = interviews.find_by(employee_id: employee_id, label: 'Manager')
        employee_interview = interviews.find_by(employee_id: employee_id, label: 'Employee')
        crossed_interview = interviews.find_by(employee_id: employee_id, label: 'Crossed')
      else
        manager_interview = interviews.find_by(interviewer: current_user, employee_id: employee_id, label: 'Manager')
        employee_interview = interviews.find_by(interviewer: current_user, employee_id: employee_id, label: 'Employee')
        crossed_interview = interviews.find_by(interviewer: current_user, employee_id: employee_id, label: 'Crossed')
      end
      {
        manager_interview: (ActiveModelSerializers::SerializableResource.new(
          manager_interview, {serializer: InterviewSerializer}
        ) if manager_interview),
        employee_interview: (ActiveModelSerializers::SerializableResource.new(
          employee_interview, {
          serializer: InterviewSerializer, include: %w[interview_form.categories employee interviewer]
        }) if employee_interview),
        crossed_interview: (ActiveModelSerializers::SerializableResource.new(
          crossed_interview, {serializer: InterviewSerializer
        }) if crossed_interview),
        status: interview_set_gen_status(employee_interview, manager_interview, crossed_interview)
      }
    end.select { |interview| interview[:employee_interview].present? }
  end

  def interview_set_gen_status(employee_interview, manager_interview, crossed_interview)
    if (employee_interview.present? && employee_interview.not_started? && manager_interview.nil? && crossed_interview.nil?) ||
      (employee_interview.present? && employee_interview.not_started? && manager_interview.present? && manager_interview.not_started? && crossed_interview.nil?) ||
      (employee_interview.present? && employee_interview.not_started? && manager_interview.present? && manager_interview.not_started? && crossed_interview.present? && (crossed_interview.not_started? || crossed_interview.not_available_yet?))
      :not_started
    elsif (employee_interview.present? && employee_interview.in_progress? && manager_interview.nil? && crossed_interview.nil?) ||
      (employee_interview.present? && employee_interview.submitted? && manager_interview.present? && !manager_interview.submitted? && crossed_interview.nil? ||
        employee_interview.present? && !employee_interview.submitted? && manager_interview.present? && manager_interview.submitted? && crossed_interview.nil?) ||
      (crossed_interview.present? && !crossed_interview.submitted?)
      :in_progress
    elsif (employee_interview.present? && employee_interview.submitted? && manager_interview.nil? && crossed_interview.nil?) ||
      (employee_interview.present? && employee_interview.submitted? && manager_interview.present? && manager_interview.submitted? && crossed_interview.nil?) ||
      (crossed_interview.present? && crossed_interview.submitted?)
      :submitted
    end
  end

  def check_user_categories(employees)
    return employees unless params[:userCategories].present? && params[:userCategories].kind_of?(Array)

    # tag_categories_to_seek = []
    # tags_to_seek = []
    params[:userCategories].each do |user_cat_json|
      user_cat = JSON.parse(user_cat_json)
      selected_tag_category = TagCategory.find_by(name: user_cat['categoryName'], company: current_user.company)
      selected_tag = Tag.find_by(tag_name: user_cat['selectedValue'], company: current_user.company)

      if selected_tag.present?
        # tag_categories_to_seek << selected_tag_category
        # tags_to_seek << selected_tag
        #
        user_ids = UserTag.where(user_id: employees.ids, tag_category: selected_tag_category, tag: selected_tag).pluck(:user_id)
        employees = User.where(id: user_ids)
      end
    end

    # if !tag_categories_to_seek.empty? && !tags_to_seek.empty?
    #   # employees = employees.where(tag_categories: tag_categories_to_seek, tags: tags_to_seek)
    #   user_ids = UserTag.where(user_id: employees.ids, tag_category: tag_categories_to_seek, tag: tags_to_seek).pluck(:user_id)
    #   employees = User.where(id: user_ids)
    # end

    employees
  end

  def filter_tag_by_interview_set(interviews)
    interview_form_ids = interviews.joins(:interview_form).distinct.pluck('interview_form_id')
    interview_forms = InterviewForm.where(id: interview_form_ids).filter_by_tag_ids(params[:tags])
    interviews.where(interview_form: interview_forms)
  end
end
