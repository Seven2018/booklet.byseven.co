class AssessmentQuestionsController < ApplicationController
  before_action :set_question, only: [:update]

  def create
    raise
    @question = AssessmentQuestion.new(title: params[:title])
    authorize @question
  end

  def update
    authorize @question
    @question.update(question_params)
    raise

    respond_to do |format|
      format.html
      format.js
    end
  end

  # def add_assessment_question
  #   authorize @module
  #   @question = AssessmentQuestion.new(title: params[:title])

  #   target_position = params.dig(:interview_question, :position).to_i + 1

  #   @form = InterviewForm.find(@question.interview_form_id)
  #   questions = @form.interview_questions.order(position: :asc)

  #   i = target_position
  #   questions.where('position >= ?', target_position).each do |question|
  #     question.update position: i
  #     i += 1
  #   end
  #   @question.position = target_position

  #   # Properly order the questions, if necessary
  #   if questions.map(&:position) != (1..questions.count).to_a
  #     j = 1
  #     questions.each do |question|
  #       question.update position: i
  #       j += 1
  #     end
  #   end

  #   params[:interview_question][:required].present? ? @question.required = true : @question.required = false

  #   @question.options =
  #     if @question.rating?
  #       {params[:interview_question][:options] => 1}
  #     elsif @question.mcq? || @question.objective?
  #       {'Please enter an option': 1}
  #     end

  #   @question.save

  #   respond_to do |format|
  #     format.html {redirect_to interview_form_path(@form)}
  #     format.js
  #   end
  # end

  private

  def set_question
    @question = AssessmentQuestion.find(params[:id])
  end

  def question_params
    params.require(:assessment_question).permit(:question)
  end
end
