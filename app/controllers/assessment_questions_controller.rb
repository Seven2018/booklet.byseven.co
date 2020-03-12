class AssessmentQuestionsController < ApplicationController

  def view_mode
    @question = AssessmentQuestion.find(params[:id])
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
    @question = AssessmentQuestion.find(params[:id])
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
    @question = AssessmentQuestion.find(params[:id])
    authorize @question
    @question.destroy
    i = 1
    @question.mod.assessment_questions.order(position: :asc).each do |question|
      question.update(position: i)
      i += 1
    end
    redirect_back(fallback_location: root_path)
  end
end
