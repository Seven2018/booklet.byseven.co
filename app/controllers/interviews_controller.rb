class InterviewsController < ApplicationController
  before_action :show_navbar_campaign
  skip_forgery_protection
  skip_after_action :verify_authorized, only: [
    :update,
  ]

  def show
    @interview = Interview.find(params[:id])
    @employee = @interview.employee
    @manager = @interview.interviewer
    @template = @interview.interview_form
    @questions = @interview.interview_questions.order(position: :asc)
    authorize @interview

    @interview.update(status: :in_progress) if @interview.status.to_sym != :submitted && @interview.status.to_sym != :in_progress
    if @interview.crossed?
      @interview.campaign.interviews.where(employee: @employee, label: ['Employee', 'Manager']).update(locked_at: Time.zone.now) if current_user == @manager
    end

    respond_to do |format|
      format.html
      format.js
      format.pdf do
        render(
          pdf: "#{@interview.employee.fullname} - #{@interview.campaign.title}",
          layout: 'pdf.html.erb',
          template: 'interviews/show',
          show_as_html: params.key?('debug'),
          page_size: 'A4',
          encoding: 'utf8',
          dpi: 75,
          zoom: 1,
        )
      end
    end
  end

  def update
    interview = Interview.find(params[:id])
    if interview.label == 'Crossed'
      date_params = JSON.parse(params['interview']).with_indifferent_access.tap do |attr|
        attr[:year] = attr[:year]
        attr[:month] = attr[:month]
        attr[:day] = attr[:day]
        attr[:min] = attr[:min]
        attr[:hour] = attr[:hour]
        attr[:duration] = attr[:duration] || 120
      end
      starts_at = Time.new(date_params[:year], date_params[:month], date_params[:day], date_params[:hour], date_params[:min]).utc
      ends_at = starts_at + date_params[:duration].to_i.minutes
      interview.update(starts_at: starts_at.to_datetime, ends_at: ends_at.to_datetime)
      CampaignMailer.with(user:current_user).cross_review_schedule(current_user, interview.campaign, interview).deliver_later
      CampaignMailer.with(user:interview.employee).cross_review_schedule(current_user, interview.campaign, interview).deliver_later
    end
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def answer_question
    answer_params = params[:interview_answer]

    answer = answer_params[:answer]
    comments = answer_params[:comments]
    objective = answer_params[:objective]
    question_id = answer_params[:interview_question_id]
    question = InterviewQuestion.find(question_id)
    interview_id = answer_params[:interview_id]

    interview = Interview.find interview_id
    authorize interview

    InterviewAnswer.find_or_initialize_by(
      interview: interview,
      interview_question_id: question_id,
      user: current_user
    ).update(
      answer: answer,
      comments: comments,
      objective: objective
    ) if answer.present?

    @fully_answered = interview.fully_answered?

    respond_to do |format|
      format.js
    end
  end

  def lock_interview
    interview_id = params[:interview_id]

    interview = Interview.find interview_id
    authorize interview

    interviewer = interview.interviewer
    interviewee = interview.employee
    campaign = interview.campaign

    unless interview.fully_answered? || interview.crossed?
      flash[:error] = 'Interview not completed'
      raise
    end

    interview.submit!
    interview.lock!

    if interview.label != 'Crossed'
      # If it's not a crossed and Manager, Employee have answer/lock then
      # we update cross review from not_available_yet to not_started
      other_interview_label = interview.employee? ? 'Manager' : 'Employee'
      other_interview = Interview.find_by(label: other_interview_label, employee: interview.employee, interviewer: interview.interviewer, campaign: interview.campaign)
      cross_interview = Interview.find_by(label: 'Crossed', employee: interview.employee, interviewer: interview.interviewer, campaign: interview.campaign)
      if cross_interview && other_interview.status.to_sym == :submitted
        cross_interview.update(status: :not_started)
      end
    end

    if interview.set.locked?

      CampaignMailer.with(user: interviewee)
                    .interview_set_completed_interviewee(interviewer, interviewee, interview)
                    .deliver_later

      CampaignMailer.with(user: interviewee)
                    .interview_set_completed_interviewer(interviewer, interviewee, interview)
                    .deliver_later

    end

    if interview.campaign.completion_for_interviewer(interviewer) == 100

      CampaignMailer.with(user: interviewer)
                    .campaign_completed(interviewer, campaign)
                    .deliver_later

    end

    redirect_to interview_path(interview)
  end

  def unlock_interview
    interview_id = params[:interview_id]

    @interview = Interview.find interview_id
    authorize @interview

    @campaign = @interview.campaign
    @employee = @interview.employee
    @selected_interviewer = User.find_by(id: params[:selected_interviewer_id])

    @interview.unlock!

    respond_to do |format|
      format.html {redirect_to campaign_path(@interview.campaign)}
      format.js
    end
  end


  ####################
  ## ARCHIVE SYSTEM ##
  ####################

  def archive_interview
    @interview = Interview.find(params[:id])
    authorize @interview

    if @interview.archived_for['Employee']
      to_archive = false
      tab = 'archived'
    else
      to_archive = true
      tab = 'ongoing'
    end

    @interview.update_archived_for('Employee', to_archive)

    redirect_to my_interviews_path(status: tab), format: 'js'
  end

  def archive_interviewer_interviews
    @interviews = Interview.where(campaign_id: params[:campaign_id],
                                  interviewer_id: params[:interviewer_id])
    authorize @interviews

    if @interviews.map{|x| x.archived_for['Manager']}.uniq == [true]
      to_archive = false
      tab = 'archived'
    else
      to_archive = true
      tab = 'ongoing'
    end

    @interviews.each do |interview|
     interview.update_archived_for('Manager', to_archive)
    end

    redirect_to my_team_interviews_path(status: tab), format: 'js'
  end

  ####################

  private

  def interview_params
    params.require(:interview).permit(:date, :starts_at, :ends_at, :employee_id, :creator_id, :interview_form_id, :campaign_id)
  end
end
