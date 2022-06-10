class CampaignsController < ApplicationController
  include InterviewUsersFilter
  before_action :set_campaign, only: %i[show edit send_notification_email destroy toggle_tag remove_company_tag search_tags index_line]
  before_action :show_navbar_admin, only: %i[index]
  before_action :show_navbar_campaign

  skip_forgery_protection
  skip_after_action :verify_authorized, only: [
    :destroy,
  ]

    def index
    campaigns = policy_scope(Campaign).where(company: current_user.company)
                                      .where_exists(:interviews)
                                      .order(created_at: :desc)

    filter_campaigns(campaigns)

    @company_tags = Category
                      .distinct
                      .where(company_id: current_user.company_id, kind: :interview)
                      .pluck(:title)

    @displayed_tags = Category.where(company_id: current_user.company_id, kind: :interview)
                              .where_exists(:campaigns)
                              .order(title: :asc)

    redirect_to my_interviews_path unless CampaignPolicy.new(current_user, nil).create?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def list
    campaigns = Campaign.where(company: current_user.company)
    campaigns = campaigns.search_campaigns(params[:title]) if params[:title]
    campaigns = campaigns.order(created_at: :desc)


    page = params[:page] && params[:page][:number] ? params[:page][:number] : 1
    size = params[:page] && params[:page][:size] ? params[:page][:size] : 10
    campaigns = campaigns.page(page).per(size)

    authorize campaigns

    render json: campaigns, meta: pagination_dict(campaigns)
  end

  def show
    cancel_cache

    authorize @campaign

    filter_interviewees

    respond_to do |format|
      format.html
      format.js
    end
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

  def send_notification_email
    authorize @campaign
    interviewee = User.find_by(id: params[:user_id])

    if interviewee.present?
      interview = Interview.find_by(campaign: @campaign, employee: interviewee, label: 'Employee')
      interviewer = interview.interviewer

      params[:email_type] == 'invite' ? invitation_email(interviewer, interviewee, interview) : reminder_email(interviewer, interviewee, interview)
    else
      @campaign.interviews.where(label: 'Employee').each do |interview|
        params[:email_type] == 'invite' ? invitation_email(interview.interviewer, interview.employee, interview) : reminder_email(interview.interviewer, interview.employee, interview)
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

  def campaign_edit_date
    @campaign = Campaign.find(params.dig(:edit_date, :campaign_id))
    authorize @campaign

    @campaign.interviews.where(employee_id: params.dig(:edit_date, :employee_id)).update_all date: params.dig(:edit_date, :date)

    head :no_content
  end

  ###########################
  ## CATEGORIES MANAGEMENT ##
  ###########################

  def toggle_tag
    authorize @campaign
    tag = params.require(:tag)
    category = Category.find_by(company_id: current_user.company_id, title: tag, kind: :interview)

    if category.nil?
      new_category = Category.create(company_id: current_user.company_id, title: tag, kind: :interview)
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

  ###########################

  private

  def filter_campaigns(campaigns)
    search_title = params.dig(:search, :title)
    search_period = params[:filter_tags].present? ? params.dig(:filter_tags, :period) : params.dig(:search, :period)

    @campaigns =
      if search_period == 'All'
        campaigns
      elsif search_period == 'Completed'
        campaigns.where_not_exists(:interviews, locked_at: nil)
      else
        campaigns.where_exists(:interviews, locked_at: nil)
      end

    if params.dig(:search, :tags).present?
      selected_tags = params.dig(:search, :tags).split(',')

      selected_tags.each do |tag|
        @campaigns = @campaigns.where_exists(:categories, id: tag)
      end
    end

    if search_title.present?
      interview_forms = InterviewForm.where(company_id: current_user.company_id).search_templates(search_title)
      campaigns_by_form = @campaigns.where_exists(:interviews, interview_form: interview_forms)
      campaigns = @campaigns.search_campaigns(search_title)
      @campaigns = @campaigns.where(id: campaigns_by_form.ids + campaigns.ids)
    end

    page_index = (params.dig(:search, :page).presence || 1).to_i

    total_campaigns_count = @campaigns.count
    @campaigns = @campaigns.page(page_index)
    @any_more = @campaigns.count * page_index < total_campaigns_count
  end

  def selected_user
    @selected_user ||= begin
                         return unless params[:search].present? && params[:search][:user_id].present?

                         User.find(params[:search][:user_id])
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

  def reminder_email(interviewer, interviewee, interview)
    CampaignMailer.with(user: interviewee)
                  .interview_reminder(interviewer, interviewee, interview)
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
end
