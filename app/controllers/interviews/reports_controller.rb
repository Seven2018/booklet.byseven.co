class Interviews::ReportsController < ApplicationController
  before_action :show_navbar_campaign, :show_navbar_admin, :set_company

  def index
    @reports = @company.interview_reports.order(created_at: :desc)
  end

  def new; end

  private

  def set_company
    @campaigns = policy_scope(Campaign)
    @company = current_user.company
    authorize @campaigns

    unless @company
      flash[:alert] = "L'utilisateur doit être associé à une société !"
      redirect_to root_path and return
    end
  end
end
