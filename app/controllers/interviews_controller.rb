class InterviewsController < ApplicationController
  before_action :show_navbar_campaign

  def create
    authorize Interview.new

    interview_form = InterviewForm.find params[:interview][:interview_form_id]
    campaign = Campaign.find(params[:interview][:campaign_id])

    unless
      (campaign.crossed? &&
      Interview.create(interview_params.merge(title: interview_form.title, label: 'Employee')) &&
      Interview.create(interview_params.merge(title: interview_form.title, label: 'Manager')) &&
      Interview.create(interview_params.merge(title: interview_form.title, label: 'Crossed'))) ||
      (campaign.simple? &&
      Interview.create(interview_params.merge(title: interview_form.title, label: 'Simple')))

      campaign&.destroy
      # Sentry 2866617584 => params[:interview][:campaign_id].nil?
      flash[:alert] = '/!\ Interviews NOT created - Campaign deleted - Please try again'
    end

    respond_to do |format|
      format.js
    end
  end

  def show
    @interview = Interview.find(params[:id])
    @employee = @interview.employee
    @manager = @interview.campaign.owner
    @questions = @interview.interview_questions.order(position: :asc)
    authorize @interview

    if @interview.crossed?
      @interview.campaign.interviews.where(employee: @employee, label: ['Employee', 'Manager']).update(locked_at: Time.zone.now) if current_user == @manager
    end
    flash[:alert] = "View mode only! New answers won't be saved!" unless
      InterviewPolicy.new(current_user, @interview).answer_question?

    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@interview.employee.fullname} - #{@interview.campaign.title}",
          layout: 'pdf.html.erb',
          template: 'interviews/show',
          show_as_html: params.key?('debug'),
          page_size: 'A4',
          encoding: 'utf8',
          dpi: 300,
          zoom: 1,
        )
      end
    end
  end

  def update_interviews
    @user_id = params[:update_interviews][:employee_id]
    @interviews = Interview.where(employee_id: @user_id, campaign_id: params[:update_interviews][:campaign_id])
    authorize @interviews.first
    @interviews.update_all(date: params[:update_interviews][:date])
    respond_to do |format|
      format.js
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
    ) if answer.present? || !question.required?

    @fully_answered = interview.fully_answered?

    respond_to do |format|
      format.js
    end
  end

  def complete_interview
    interview_id = params[:interview_id]

    interview = Interview.find interview_id
    authorize interview

    interview.complete!

    head :no_content
  end

  def lock_interview
    interview_id = params[:interview_id]

    interview = Interview.find interview_id
    authorize interview

    interview.complete!
    interview.lock!

    head :no_content
  end

  def unlock_interview
    interview_id = params[:interview_id]

    @interview = Interview.find interview_id
    authorize @interview

    @interview.unlock!

    respond_to do |format|
      format.html {redirect_to campaign_path(@interview.campaign)}
      format.js
    end
  end

  private

  def interview_params
    params.require(:interview).permit(:date, :starts_at, :ends_at, :employee_id, :creator_id, :interview_form_id, :campaign_id)
  end
end
