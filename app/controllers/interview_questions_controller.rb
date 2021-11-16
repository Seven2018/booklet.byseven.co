class InterviewQuestionsController < ApplicationController
  before_action :set_question, only: [:delete_mcq_option, :update, :move_up, :move_down, :destroy]

  def create
    @question = InterviewQuestion.new(question_params)
    @form = InterviewForm.find(@question.interview_form_id)
    authorize @question
    @question.position = @form.interview_questions.order(position: :asc).count + 1
    params[:interview_question][:required].present? ? @question.required = true : @question.required = false
    if @question.question_type == 'rating'
      @question.options = {params[:interview_question][:options] => 1}
    end
    @question.save
    respond_to do |format|
      format.html {redirect_to interview_form_path(@form)}
      format.js
    end
  end

  def update
    authorize @question
    @question.update(question_params)
    params[:interview_question][:required].present? ? @question.update(required: true) : @question.update(required: false)
    if @question.question_type == 'rating'
      @question.update(options: {params[:interview_question][:options] => 1})
    end
    respond_to do |format|
      format.html {redirect_to interview_form_path(@question.interview_form)}
      format.js
    end
  end

  def add_mcq_option
    @question = InterviewQuestion.find(params[:add_option][:question_id])
    authorize @question
    @form = @question.interview_form
    unless @question.options[params[:add_option][:option]].present?
      options_hash = @question.options
      options_hash[params[:add_option][:option]] = options_hash.count + 1
      @question.update(options: options_hash)
    end
    respond_to do |format|
      format.html {redirect_to interview_form_path(@question.interview_form)}
      format.js
    end
  end

  def edit_mcq_option
    @question = InterviewQuestion.find(params[:edit_option][:question_id])
    authorize @question
    @form = @question.interview_form
    options_hash = @question.options
    options_hash.delete(options_hash.key(params[:edit_option][:position].to_i))
    options_hash[params[:edit_option][:option]] = params[:edit_option][:position].to_i
    @question.update(options: options_hash)
    respond_to do |format|
      format.html {redirect_to interview_form_path(@question.interview_form)}
      format.js
    end
  end

  def delete_mcq_option
    authorize @question
    @form = @question.interview_form
    options_hash = @question.options
    options_hash.delete(params[:option])
    i = 1
    options_hash.each do |k,v|
      options_hash[k] = i
      i += 1
    end
    @question.update(options: options_hash)
    respond_to do |format|
      format.html {redirect_to interview_form_path(@question.interview_form)}
      format.js
    end
  end

  def move_up
    skip_authorization
    @template = @question.interview_form
    position = @question.position
    @previous_question = @template.interview_questions.find_by(position: position - 1)
    @previous_question.update(position: position)
    @question.update(position: position - 1)
    respond_to do |format|
      format.html {redirect_to interview_form_path(@template)}
      format.js
    end
  end

  def move_down
    skip_authorization
    @template = @question.interview_form
    position = @question.position
    @previous_question = @template.interview_questions.find_by(position: position + 1)
    @previous_question.update(position: position)
    @question.update(position: position + 1)
    respond_to do |format|
      format.html {redirect_to interview_form_path(@template)}
      format.js
    end
  end

  def destroy
    authorize @question
    @form = @question.interview_form
    @question.destroy
    respond_to do |format|
      format.html {redirect_to interview_form_path(@form)}
      format.js
    end
  end

  private

  def set_question
    @question = InterviewQuestion.find(params[:id])
  end

  def question_params
    params.require(:interview_question).permit(:question, :description, :question_type, :allow_comments, :interview_form_id)
  end
end
