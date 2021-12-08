class InterviewsController < ApplicationController

  def create
    new_interview_employee = Interview.new(interview_params)
    new_interview_hr = Interview.new(interview_params)
    new_interview_final = Interview.new(interview_params)
    authorize new_interview_employee
    title = InterviewForm.find(params[:interview][:interview_form_id])
    new_interview_employee.title, new_interview_employee.label = title, 'Employee'
    new_interview_hr.title, new_interview_hr.label = title, 'HR'
    new_interview_final.title, new_interview_final.label = title, 'Crossed'
    new_interview_employee.save
    new_interview_hr.save
    new_interview_final.save
    respond_to do |format|
      format.js
    end
  end

  def show
    @interview = Interview.find(params[:id])
    @employee = @interview.employee
    @manager = @interview.campaign.owner
    @questions = @interview.interview_form.interview_questions.order(position: :asc)
    authorize @interview
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
      comments: comments
    )

    interview.complete!
    head :no_content
  end

  private

  def interview_params
    params.require(:interview).permit(:date, :starts_at, :ends_at, :employee_id, :creator_id, :interview_form_id, :campaign_id)
  end
end
