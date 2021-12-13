class Interview::Answer::AuthorizationChecksController < ApplicationController
  skip_after_action :verify_authorized, only: :create

  def create
    answer_params = params[:interview_answer]

    answer = answer_params[:answer]
    comments = answer_params[:comments]
    question_id = answer_params[:interview_question_id]
    interview_id = answer_params[:interview_id]

    interview = Interview.find interview_id
    can_answer_question = InterviewPolicy.new(current_user, interview).answer_question?
    render json: { can_answer_question: can_answer_question }
  end
end
