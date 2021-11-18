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
    authorize @interview
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
    interview = Interview.find(params[:interview_answer][:interview_id])
    authorize interview
    interview_question = InterviewQuestion.find(params[:interview_answer][:interview_question_id])
    interview_answer = InterviewAnswer.find_by(interview_id: params[:interview_answer][:interview_id], interview_question_id: params[:interview_answer][:interview_question_id], user_id: current_user.id)
    if interview_answer.present?
      interview_answer.update(answer: params[:interview_answer][:answer])
    else
      interview_answer = InterviewAnswer.new(interview_id: params[:interview_answer][:interview_id], interview_question_id: params[:interview_answer][:interview_question_id], user_id: current_user.id, answer: params[:interview_answer][:answer])
    end
    interview_answers = InterviewAnswer.where(interview_id: params[:interview_answer][:interview_id])
    if interview_answers.count >= interview.interview_form.interview_questions.where.not(question_type: 'separator').where(required: true).count
      interview.update(completed: true) if interview.completed != true
    end
    interview_answer.save
    return
  end

  private

  def interview_params
    params.require(:interview).permit(:date, :starts_at, :ends_at, :employee_id, :creator_id, :interview_form_id, :campaign_id)
  end
end
