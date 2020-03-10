class AssessmentsController < ApplicationController
  before_action :set_assessment, only: [:show, :edit, :update, :destroy, :add_questions]

  def show
    authorize @form
  end

  # def new
  #   @form = Assessment.new
  #   authorize @form
  # end

  def create
    @form = Assessment.new(assessment_params)
    authorize @form
    @mod = Mod.find(params[:mod_id])
    @form.mod_id = @mod.id
    if @form.save
      redirect_to mod_assessment_path(@mod, @form)
    end
  end

  def add_questions
    authorize @form
    @question = AssessmentQuestion.create(question: params[:assessment_question][:question], answer: params[:assessment_question][:answer], question_type: params[:assessment_question][:question_type], assessment_id: @form.id, position: @form.assessment_questions.count + 1)
    respond_to do |format|
      format.html {redirect_to mod_assessment_path(@form.mod, @form)}
      format.js
    end
  end

  def edit
    authorize @form
  end

  def update
    authorize @form
    @form.update(assessment_params)
    redirect_to mod_assessment_path(@mod, @form) if @form.save
  end

  def destroy
    authorize @form
    @form.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def set_assessment
    @form = Assessment.find(params[:id])
  end

  def assessment_params
    params.require(:assessment).permit(:title)
  end

  def assessment_question_params
    params.require(:assessment_question).permit(:question, :answer)
  end
end
