class CampaignsController < ApplicationController
  before_action :set_campaign, only: %i[show overview update send_notification_email destroy toggle_tag remove_company_tag search_tags index_line]
  before_action :show_navbar_campaign

  skip_forgery_protection
  skip_after_action :verify_authorized, only: [
    :destroy,
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
    end
  end

  def overview
    cancel_cache

    authorize @campaign

    @campaign = @campaign.decorate
    campaign_id = @campaign.id

    @tag_categories = TagCategory.where(company_id: current_user.company_id).order(position: :asc)

    @employees = @campaign.employees.order(lastname: :asc)

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
    @campaigns = policy_scope(Campaign).where(company: current_user.company).order(created_at: :desc)
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

    calendar_create_event(instance, user, service)

    redirect_to my_interviews_path
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

    @employees = @employees.select{|x| @campaign.completion_status(x) == search_completion} \
      if ['not_started', 'in_progress', 'completed'].include?(search_completion)

    @employees = @employees.uniq
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
end
