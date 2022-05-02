class InterviewQuestionsController < ApplicationController
  before_action :set_question, only: [:update, :duplicate, :delete_mcq_option, :move_up, :move_down, :destroy]

  def create
    @question, @form = InterviewQuestions::Create.call(
      question: question_params[:question],
      question_type: question_params[:question_type],
      interview_form_id: question_params[:interview_form_id],
      position: question_params[:position]
    )
    authorize @question
    respond_to do |format|
      format.html {redirect_to interview_form_path(@form)}
      format.js
    end
  end

  def update
    authorize @question
    @question.update(question_params)

    if @question.rating? && params.dig(:interview_question, :options).present?
      @question.update(options: {params.dig(:interview_question, :options) => 1})
    end

    if params.dig(:interview_question, :requirement_and_visibility).present?

      required_for_employee = params.dig(:interview_question, :required_for_employee) == 'on' ?  'employee' : nil
      required_for_manager = params.dig(:interview_question, :required_for_manager) == 'on' ? 'manager' : nil
      required_for_all = required_for_employee && required_for_manager ? 'all' : nil
      required_for = 'none'
      [required_for_all, required_for_employee, required_for_manager].each do |element|
        if element.present?
          required_for = element
          break
        end
      end
      visible_for_employee = params.dig(:interview_question, :visible_for_employee) == 'on' ?  'employee' : nil
      visible_for_manager = params.dig(:interview_question, :visible_for_manager) == 'on' ? 'manager' : nil
      visible_for_all = visible_for_employee && visible_for_manager ? 'all' : nil

      visible_for = 'all'
      [visible_for_all, visible_for_employee, visible_for_manager].each do |element|
        if element.present?
          visible_for = element
          break
        end
      end

      @question.update(required_for: required_for, visible_for: visible_for)

    end

    respond_to do |format|
      format.html {redirect_to edit_interview_form_path(@question.interview_form)}
      format.js
    end
  end

  def duplicate
    authorize @question
    @template = @question.interview_form

    new_question = InterviewQuestion.new(
      @question.attributes
               .merge(question: @question.question + ' (copy)')
               .except('id', 'position', 'created_at', 'updated_at')
    )

    new_question.position = @question.position + 1
    new_question.save

    respond_to do |format|
      format.html {redirect_to edit_interview_form_path(@template)}
      format.js
    end
  end

  def add_mcq_option
    @question = InterviewQuestion.find(params.dig(:add_option, :question_id))
    authorize @question
    @form = @question.interview_form
    unless @question.options[params.dig(:add_option, :option)].present?
      options_hash = @question.options
      options_hash[params.dig(:add_option, :option)] = options_hash.count + 1
      @question.update(options: options_hash)
    end
    respond_to do |format|
      format.html {redirect_to interview_form_path(@question.interview_form)}
      format.js
    end
  end

  def edit_mcq_option
    @question = InterviewQuestion.find(params.dig(:edit_option, :question_id))
    authorize @question
    @form = @question.interview_form
    options_hash = @question.options
    options_hash.delete(options_hash.key(params.dig(:edit_option, :position).to_i))
    options_hash[params.dig(:edit_option, :option)] = params.dig(:edit_option, :position).to_i
    @question.update(options: options_hash)

    respond_to do |format|
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
    params.require(:interview_question).permit(:question, :description, :question_type, :allow_comments, :interview_form_id, :position)
  end
end
