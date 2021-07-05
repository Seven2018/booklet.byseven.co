class AssessmentsController < ApplicationController
  before_action :set_assessment, only: [:add_questions, :add_answers]

  # Create a new Assessment (contents/edit_mode)
  def create_ajax
    @content = Content.find(params[:new_assessment][:content_id])
    @form = Assessment.new(title: params[:new_assessment][:title], mod_type: 'assessment', company_id: current_user.company_id, content_id: @content.id, duration: params[:new_assessment][:duration])
    authorize @form
    @form.position = @content.mods.order(position: :asc).count + 1
    if @form.save
      @content.update(duration: @content.mods.map(&:duration).sum)
      respond_to do |format|
        format.html {redirect_to content_path(@content)}
        format.js
      end
    end
  end

  # Add questions to an Assessment (contents/edit_mode)
  def add_questions
    authorize @form
    @question = AssessmentQuestion.create(question: params[:assessment_question][:question], question_type: params[:assessment_question][:question_type], mod_id: @form.id, position: @form.assessment_questions.count + 1)
    options = {}
    params[:options].reject!(&:empty?).each_with_index do |key, index|
      options[key] = params[:answer][index]
    end
    @question.update(options: options)
    respond_to do |format|
      format.js
    end
  end

  def edit_question
    @question = AssessmentQuestion.find(params[:id])
    @form = @question.mod
    authorize @form
    @question.update(question: params[:assessment_question][:question])
    options = {}
    params[:options].reject!(&:empty?).each_with_index do |key, index|
      options[key] = params[:answer][index]
    end
    @question.update(options: options)
    respond_to do |format|
      format.js
    end
  end

  # Submit answers for an assessment (assessment_questions/view_mode)
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
      AssessmentAnswer.joins(:assessment_question).where(user_id: current_user.id, assessment_questions: {mod_id: @form.id}).each do |answer|
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
      redirect_to content_path(@form.content)
    end
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
