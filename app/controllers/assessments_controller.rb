class AssessmentsController < ApplicationController
  before_action :set_assessment, only: [:show, :view_mode, :edit, :update, :destroy, :add_questions, :add_answers]

  def show
    authorize @form
  end

  def create
    @form = Assessment.new(assessment_params)
    @form.company_id = current_user.company_id
    authorize @form
    @form.media = ''
    @content = Content.find(params[:content_id])
    if @form.save
      ContentMod.create(content_id: @content.id, mod_id: @form.id, position: @content.content_mods.count + 1)
      redirect_to assessment_path(@form)
    end
  end

  def create_ajax
    skip_authorization
    @content = Content.find(params[:new_assessment][:content_id])
    @form = Assessment.new(title: params[:new_assessment][:title], mod_type: 'assessment', company_id: current_user.company_id, content_id: @content.id)
    if @form.save

      respond_to do |format|
        format.html {redirect_to content_path(@content)}
        format.js
      end
    end
  end

  def update_ajax
    skip_authorization
    @form = Assessment.find(params[:id])
    @form.update(title: params[:update_assessment][:title])
    if @form.save
      respond_to do |format|
        format.html {redirect_to new_content_path}
        format.js
      end
    end
  end

  def add_questions
    authorize @form
    @question = AssessmentQuestion.create(question: params[:assessment_question][:question], question_type: params[:assessment_question][:question_type], mod_id: @form.id, position: @form.assessment_questions.count + 1)
    # if params[:assessment_question][:question_type] == 'MCQ'
      options = {}
      params[:options].reject!(&:empty?).each_with_index do |key, index|
        options[key] = params[:answer][index]
      end
      @question.update(options: options)
    # elsif params[:assessment_question][:question_type] == 'rating'
    #   options = {start: params[:rating].map(&:to_i)[0], end: params[:rating].map(&:to_i)[1]}
    #   @question.update(options: options)
    # end
    respond_to do |format|
      format.html {redirect_to content_path(@form.content)}
      format.js
    end
  end

  def add_questions_ajax
    raise
    skip_authorization
  end

  def add_answers
    authorize @form
    @question = AssessmentQuestion.find(params[:question_id])
    if AssessmentAnswer.find_by(user_id: current_user.id, assessment_question_id: @question.id).present?
      @answer = AssessmentAnswer.find_by(user_id: current_user.id, assessment_question_id: @question.id)
      @answer.update(answer: params[:assessment_answer][:answer])
    else
      @answer = AssessmentAnswer.new(answer: params[:assessment_answer][:answer], assessment_question_id: @question.id, user_id: current_user.id)
    end
    @next_question = AssessmentQuestion.find_by(mod_id: @form.id, position: @question.position + 1)
    if @answer.save && @question.position != @form.assessment_questions.count
      redirect_to assessment_view_mode_assessment_question_path(@form, @next_question)
    else
      correct_answers = 0
      wrong_answers = 0
      AssessmentAnswer.joins(:assessment_question).where(user_id: current_user.id, assessment_questions: {question_type: 'MCQ', mod_id: @form.id}).each do |answer|
        if answer.assessment_question.options[answer.answer] == 'true'
          answer.update(correct: true)
          correct_answers += 1
        else
          answer.update(correct: false)
          wrong_answers += 1
        end
      end
      grade = correct_answers.fdiv(correct_answers + wrong_answers)
      form = UserForm.find_by(user_id: current_user.id, mod_id: @form.id)
      if form.present?
        form.update(grade: (grade*100))
      else
        UserForm.create(grade: (grade*100).round, user_id: current_user.id, mod_id: @form.id)
      end
      redirect_to view_content_path(Content.joins(:content_mods).find_by(content_mods: {mod_id: @form.id}))
    end
  end

  def edit
    authorize @form
  end

  def update
    authorize @form
    @form.update(assessment_params)
    redirect_to assessment_path(@form) if @form.save
  end

  def destroy
    authorize @form
    @form.destroy
    @content = Content.find(params[:content_id])
    i = 1
    @content.content_mods.order(position: :asc).each do |content_mod|
      content_mod.update(position: i)
      i += 1
    end
    redirect_to content_path(@content)
  end

  private

  def set_assessment
    @form = Assessment.find(params[:id])
  end

  def assessment_params
    params.require(:assessment).permit(:title, :duration, :content, :document, :media)
  end

  def assessment_question_params
    params.require(:assessment_question).permit(:question, :answer)
  end
end
