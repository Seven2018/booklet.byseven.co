class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:campaign_report_info, :show, :edit, :send_notification_email, :destroy]

  def index
    @campaigns = policy_scope(Campaign)
    @campaigns = @campaigns.where(company_id: current_user.company_id)
    authorize @campaigns
    if current_user.manager?
      @campaigns = @campaigns.where(owner_id: current_user.id)
    elsif ['HR-light', 'Manager-light', 'Employee'].include?(current_user.access_level)
      @campaigns = @campaigns.joins(:interviews).where(interviews: {employee_id: current_user.id}).distinct
    end
    if params[:search].present? && params[:search][:period] == 'Completed'
      @campaigns = @campaigns.where_not_exists(:interviews, 'completed = ?', false)
    elsif params[:search].present? && params[:search][:period] == 'All'
    else
      @campaigns = @campaigns.where_exists(:interviews, 'completed = ?', false)
    end
    if params[:search].present? && !(params[:search][:title] == '')
      @campaigns = @campaigns.where(interview_form_id: InterviewForm.where(company_id: current_user.company_id).search_templates(params[:search][:title]).map(&:id))
      @filtered = 'true'
    else
      @filtered = 'false'
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def campaigns_report
    @campaigns = policy_scope(Campaign)
    @campaigns = @campaigns.where(company_id: current_user.company_id)
    @managers = User.where(company_id: current_user.company_id, access_level: ['HR', 'HR-light', 'Manager', 'Manager-light']).order(lastname: :asc)
    @selected_manager_id = ''
    authorize @campaigns
    if params[:select_period].present?
      @start_date = params[:select_period][:start].to_date
      @end_date = params[:select_period][:end].to_date
      @campaigns = @campaigns.where_exists(:interviews, 'date >= ? AND date <= ?', @start_date, @end_date)
      @all_campaigns = @campaigns
      @reload_control = 'true'
      if params[:select_period][:campaigns] == 'ongoing'
        @campaigns = @campaigns.where_exists(:interviews, completed: false)
        @reload_control = 'false'
      elsif params[:select_period][:campaigns] == 'completed'
        @campaigns = @campaigns.where_not_exists(:interviews, completed: false)
        @reload_control = 'false'
      end
      if params[:select_period][:name] != ''
        @managers = User.where(company_id: current_user.company_id, access_level: ['HR', 'HR-light', 'Manager', 'Manager-light']).search_by_name("#{params[:select_period][:name]}").order(lastname: :asc)
        params[:select_period].present? ? @selected_manager_id = params[:select_period][:manager_id] : @selected_manager_id = ''
      end
      @all_campaigns = @campaigns
      if params[:select_period][:manager_id].present?
        @selected_manager_id = params[:select_period][:manager_id]
        @campaigns = @campaigns.where(owner_id: params[:select_period][:manager_id])
      end
    else
      @campaigns = @campaigns.where_exists(:interviews, 'date >= ? AND date <= ?', Date.today, Date.today.end_of_year)
      @all_campaigns = @campaigns
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def campaign_report_info
    authorize @campaign
    respond_to do |format|
      format.js
    end
  end

  def campaign_select_template
    @campaign = Campaign.new
    authorize @campaign
    @templates = InterviewForm.where(company_id: current_user.company_id)
    if params[:search].present? && !params[:search][:title].blank?
      @templates = @templates.search_templates(params[:search][:title]).order(title: :asc)
      @filtered = 'true'
    else
      @filtered = 'false'
    end
    params[:search].present? ? @selected_template = params[:search][:campaign_selected_template] : campaign_data
  end

  def campaign_select_users
    @campaign = Campaign.new
    authorize @campaign
    @users = User.where(company_id: current_user.company_id)
    if params[:search].present? && !params[:search][:name].blank?
      @searched_users = @users.search_by_name("#{params[:search][:name]}")
      @filtered = 'true'
    else
      @searched_users = []
      @filtered = 'false'
    end
    @users = @users.order(lastname: :asc).page params[:page]
    params[:search].present? ? @selected_users = params[:search][:campaign_selected_users] : campaign_data
    respond_to do |format|
      format.html {book_users_path}
      format.js
    end
  end

  def campaign_select_dates
    @campaign = Campaign.new
    authorize @campaign
    campaign_data
    @selected_users = User.where(id: @selected_users.split(','))
  end

  def create
    @campaign = Campaign.new(title: params[:campaign][:title], interview_form_id: params[:campaign][:interview_form_id], owner_id: params[:campaign][:selected_owner])
    authorize @campaign
    @campaign.company_id = current_user.company_id
    @campaign.save
    respond_to do |format|
      format.js
    end
  end

  def show
    authorize @campaign
    # if ['HR-light', 'Manager-light', 'Employee'].include?(current_user.access_level)
    #   target = Interview.find_by(campaign_id: @campaign.id, employee_id: current_user.id, label: 'Employee')
    #   target.present? ? (redirect_to interview_path(target)) : (redirect_to root_path)
    # end

    @current_user_employee = ['HR-light', 'Manager-light', 'Employee'].include?(current_user.access_level)
    @interviews_for_date =
      if @current_user_employee
        @campaign.interviews.find_by(employee: current_user)
      else
        @campaign.interviews.order(date: :asc)
      end

    @completion =
      if @current_user_employee
        @campaign.completion_for(current_user)
      else
        @campaign.completion_for(:all)
      end

    @interviews =
      if selected_user.present?
        Interview.where(campaign_id: @campaign.id, employee_id: selected_user.id)
      else
        []
      end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def send_notification_email
    authorize @campaign
    @campaign.interviews.where(label: 'Employee').each do |interview|
      CampaignMailer.with(user: interview.employee).invite_employee(@campaign.owner, interview.employee, interview).deliver
    end
    redirect_to campaigns_path, notice: 'Email(s) sent'
  end

  def edit
    authorize @campaign
  end

  def destroy
    authorize @campaign
    @target = "campaign-card-#{@campaign.id}"
    @campaign.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def selected_user
    @selected_user ||= begin
      return unless params[:search].present? && params[:search][:user_id].present?

      User.find(params[:search][:user_id])
    end
  end

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
