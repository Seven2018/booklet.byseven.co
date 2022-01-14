class InterviewsController < ApplicationController

  def create
    authorize Interview.new

    interview_form = InterviewForm.find params[:interview][:interview_form_id]

    unless
      Interview.create(interview_params.merge(title: interview_form.title, label: 'Employee')) &&
      Interview.create(interview_params.merge(title: interview_form.title, label: 'Manager')) &&
      Interview.create(interview_params.merge(title: interview_form.title, label: 'Crossed'))

      Campaign.find(params[:interview][:campaign_id])&.destroy
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

    flash[:alert] = "View mode only! New answers won't be saved!" unless
      InterviewPolicy.new(current_user, @interview).answer_question?

    params[:show_review].present? ? @show_review = 'true' : @show_review = 'false'
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update_interviews
    @user_id = params[:update_interviews][:employee_id]
    @interviews = Interview.where(employee_id: @user_id, campaign_id: params[:update_interviews][:campaign_id])
    authorize @interviews.first
    @interviews.update_all(date: params[:update_interviews][:date], starts_at: DateTime.strptime(params[:update_interviews][:starts_at], '%H:%M'), ends_at: DateTime.strptime(params[:update_interviews][:ends_at], '%H:%M'))
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
    )

    interview.complete!
    head :no_content
  end

  def show_crossed_and_lock
    interview = Interview.find(params[:id])
    authorize interview
    campaign = interview.campaign
    employee = interview.employee
    manager = campaign.owner

    interview.campaign.interviews.where(employee: employee, label: ['Employee', 'Manager']).update(locked_at: Time.zone.now) if current_user = manager
    redirect_to interview_path(interview)
  end

  private

  def interview_params
    params.require(:interview).permit(:date, :starts_at, :ends_at, :employee_id, :creator_id, :interview_form_id, :campaign_id)
  end
end
