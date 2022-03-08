class Trainings::ReportsController < ApplicationController
  # before_action :show_navbar_campaign, :show_navbar_admin, :set_company
  before_action :show_navbar_training, :show_navbar_admin
  skip_after_action :verify_policy_scoped # temp

  def index
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
      format.html {trainings_reports_path}
      format.js
    end
  end
end
