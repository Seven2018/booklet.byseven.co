class InterviewQuestionsController < ApplicationController
  before_action :set_question, only: [:delete_mcq_option, :update, :move_up, :move_down, :destroy]

  def create
    @question = InterviewQuestion.new(question_params)
    authorize @question

    target_position = params.dig(:interview_question, :position).to_i + 1

    @form = InterviewForm.find(@question.interview_form_id)
    questions = @form.interview_questions.order(position: :asc)

    i = target_position
    questions.where('position >= ?', target_position).each do |question|
      question.update position: i
      i += 1
    end
    @question.position = target_position

    # Properly order the questions, if necessary
    if questions.map(&:position) != (1..questions.count).to_a
      j = 1
      questions.each do |question|
        question.update position: i
        j += 1
      end
    end

    params[:interview_question][:required].present? ? @question.required = true : @question.required = false
    if @question.rating?
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

    required_for_employee = params.dig(:interview_question, :required_for_employee).present? ?  'employee' : nil
    required_for_manager = params.dig(:interview_question, :required_for_manager).present? ? 'manager' : nil
    required_for_all = required_for_employee && required_for_manager ? 'all' : nil

    required_for = 'none'
    [required_for_all, required_for_employee, required_for_manager].each do |element|
      if element.present?
        required_for = element
        break
      end
    end

    visible_for_employee = params.dig(:interview_question, :visible_for_employee).present? ?  'employee' : nil
    visible_for_manager = params.dig(:interview_question, :visible_for_manager).present? ? 'manager' : nil
    visible_for_all = visible_for_employee && visible_for_manager ? 'all' : nil

    visible_for = 'all'
    [visible_for_all, visible_for_employee, visible_for_manager].each do |element|
      if element.present?
        visible_for = element
        break
      end
    end

    # raise
    @question.update required_for: required_for
    @question.update visible_for: visible_for

    if @question.rating?
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

    head :no_content
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
    @question.move_higher
    respond_to do |format|
      format.html {redirect_to interview_form_path(@template)}
      format.js
    end
  end

  def move_down
    skip_authorization
    @template = @question.interview_form
    @question.move_lower
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
