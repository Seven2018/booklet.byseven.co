class AssessmentQuestionsController < ApplicationController
  before_action :set_question, only: [:view_mode, :update, :destroy, :move_up, :move_down]

  def view_mode
    authorize @question
    @form = @question.mod
    @previous_question = AssessmentQuestion.find_by(mod_id: @question.mod_id, position: @question.position - 1)
    if AssessmentAnswer.find_by(user_id: current_user.id, assessment_question_id: @question.id).present?
      @answer = AssessmentAnswer.find_by(user_id: current_user.id, assessment_question_id: @question.id)
    else
      @answer = AssessmentAnswer.new
    end
  end

  def update
    authorize @question
    @question.update(question: params[:assessment_question][:question], question_type: params[:assessment_question][:question_type])
    if params[:assessment_question][:question_type] == 'MCQ'
      options = {}
      params[:options].reject!(&:empty?).each_with_index do |key, index|
        options[key] = params[:answer][index]
        options[key] = 'true' if options[key] == "1"
      end
      @question.update(options: options)
    elsif params[:assessment_question][:question_type] == 'rating'
      options = {start: params[:rating].map(&:to_i)[0], end: params[:rating].map(&:to_i)[1]}
      @question.update(options: options)
    end
    if @question.save
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    authorize @question
    @question.destroy
    @form = @question.mod
    i = 1
    @question.mod.assessment_questions.order(position: :asc).each do |question|
      question.update(position: i)
      i += 1
    end
    respond_to do |format|
      format.js
    end
  end

  def move_up
    authorize @question
    @form = @question.mod
    unless @question.position == 1
      previous_question = @form.assessment_questions.where(position: @question.position - 1).first
      previous_question.update(position: @question.position)
      @question.update(position: (@question.position - 1))
    end
    @question.save
    respond_to do |format|
      format.js
    end
  end

  def move_down
    authorize @question
    @form = @question.mod
    unless @question.position == @form.assessment_questions.count
      next_question = @form.assessment_questions.where(position: @question.position + 1).first
      next_question.update(position: @question.position)
      @question.update(position: (@question.position + 1))
    end
    @question.save
    respond_to do |format|
      format.html {redirect_to assessment_path(@question.mod)}
      format.js
    end
  end

  private

  def set_question
    @question = AssessmentQuestion.find(params[:id])
  end
end
