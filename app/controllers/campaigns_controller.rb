class CampaignsController < ApplicationController

  def index
    @campaigns = policy_scope(Campaign)
    @campaigns = @campaigns.where(company_id: current_user.company_id)
    authorize @campaigns
    if ['Manager'].include?(current_user.access_level)
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
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def campaign_select_template
    @campaign = Campaign.new
    authorize @campaign
    @templates = InterviewForm.where(company_id: current_user.company_id)
    if params[:search].present? && !params[:search][:title].blank?
      @templates = @templates.search_templates(params[:search][:title]).order(title: :asc)
    end
    params[:search].present? ? @selected_template = params[:search][:campaign_selected_template] : campaign_data
  end

  def campaign_select_users
    @campaign = Campaign.new
    authorize @campaign
    @users = User.where(company_id: current_user.company_id)
    if params[:search].present? && !params[:search][:name].blank?
      @users = @users.search_by_name("#{params[:search][:name]}")
      @filter = 'true'
    else
      @filter = 'false'
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
    @campaign = Campaign.new(title: params[:campaign][:title], interview_form_id: params[:campaign][:interview_form_id])
    authorize @campaign
    @campaign.owner_id = current_user.id
    @campaign.company_id = current_user.company_id
    @campaign.save
    respond_to do |format|
      format.js
    end
  end

  def show
    @campaign = Campaign.find(params[:id])
    authorize @campaign
    if ['HR-light', 'Manager-light', 'Employee'].include?(current_user.access_level)
      target = Interview.find_by(campaign_id: @campaign.id, employee_id: current_user.id, label: 'Employee')
      target.present? ? (redirect_to interview_path(target)) : (redirect_to root_path)
    end
    @interviews = []
    selected_user = User.find(params[:search][:user_id]) if params[:search].present? && params[:search][:user_id] != ''
    if selected_user.present?
      @interviews = Interview.where(campaign_id: @campaign.id, employee_id: selected_user.id)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def campaign_data
    if params[:campaign].present?
      @selected_template = params[:campaign][:selected_template]
      @selected_users = params[:campaign][:selected_users]
    end
  end
end
