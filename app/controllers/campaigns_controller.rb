class CampaignsController < ApplicationController
  include InterviewUsersFilter
  before_action :set_campaign, only: %i[show edit send_notification_email destroy]
  before_action :show_navbar_admin, only: %i[index]
  before_action :show_navbar_campaign

  def index
    @company_tags = Category
                      .distinct
                      .where(company_id: current_user.company_id)
                      .pluck(:title)
    campaigns = policy_scope(Campaign).where(company: current_user.company)
                                      .where_exists(:interviews)
                                      .order(created_at: :desc)

    filter_campaigns(campaigns)

    redirect_to my_interviews_path unless CampaignPolicy.new(current_user, nil).create?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
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
    end
  end

  def my_interviews
    @campaigns = Campaign.where(company: current_user.company).order(created_at: :desc).where \
      id: Interview.where(employee: current_user).distinct.pluck(:campaign_id)
    authorize @campaigns

    @ongoing_campaigns = @campaigns.where_exists(:interviews, employee: current_user, locked_at: nil)
    @completed_campaigns = @campaigns.where_not_exists(:interviews, employee: current_user, locked_at: nil)

    @campaigns =
      if params.dig(:period) == 'completed'
        @completed_campaigns
      else
        @ongoing_campaigns
      end

    @campaigns = CampaignDecorator.decorate_collection @campaigns

    @interviews_to_fill_count = Interview.where(employee: current_user, label: 'Employee').where.not(status: :submitted).count

    respond_to do |format|
      format.html
      format.js
    end
  end

  def my_team_interviews
    campaigns = policy_scope(Campaign).where(company: current_user.company).order(created_at: :desc)
    campaigns = campaigns.where_exists(:interviews, interviewer: current_user)
    authorize campaigns

    @interviews_completed_count = Interview.where(interviewer: current_user,
                                                  label: ['Manager', 'Crossed'],
                                                  locked_at: nil)
                                           .count
    @interviews_to_fill_count = Interview
                                  .where(interviewer: current_user, label: ['Manager', 'Crossed'])
                                  .where.not(status: :submitted).count

    @ongoing_campaigns = campaigns.where_exists(:interviews, interviewer: current_user, locked_at: nil)
    @completed_campaigns = campaigns.where_not_exists(:interviews, interviewer: current_user, locked_at: nil)

    @campaigns =
      if params.dig(:period) == 'completed'
        @completed_campaigns
      else
        @ongoing_campaigns
      end

    @campaigns = @campaigns.sort { |x| x.deadline }.reverse
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
    end
  end

  def campaign_edit_date
    @campaign = Campaign.find(params.dig(:edit_date, :campaign_id))
    authorize @campaign

    @campaign.interviews.where(employee_id: params.dig(:edit_date, :employee_id)).update_all date: params.dig(:edit_date, :date)

    head :no_content
  end

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

      @campaigns = Campaign
                     .where(company_id: current_user.company_id)
                     .tag_matches(selected_tags)
                     .select { |campaign| (selected_tags & campaign.tags) == selected_tags }
      @campaigns = Campaign.get_activerecord_relation(@campaigns) # to cast Array to ActiveRecord Relation
      @filtered_by_tags = 'true'
    end

    if search_title.present?
      interview_forms = InterviewForm.where(company_id: current_user.company_id).search_templates(search_title)
      campaigns_by_form = @campaigns.where(interview_form: interview_forms)
      campaigns = @campaigns.search_campaigns(search_title)
      @campaigns = @campaigns.where(id: campaigns_by_form.ids + campaigns.ids)
      @filtered = true
    else
      @filtered_by_tags = 'false'
      @filtered = false
    end

    page_index = params.dig(:search, :page).present? ? params.dig(:search, :page).to_i : 1

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
