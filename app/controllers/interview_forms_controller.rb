class InterviewFormsController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :duplicate, :destroy]

  def index
    @templates = policy_scope(InterviewForm)
    @templates = @templates.where(company_id: current_user.company_id)
    if params[:search].present? && !params[:search][:title].blank?
      @templates = @templates.search_templates(params[:search][:title]).order(title: :asc)
      @filtered = 'true'
    else
      @filtered = 'false'
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @template = InterviewForm.new(template_params)
    authorize @template
    @template.company_id = current_user.company_id
    redirect_to interview_form_path(@template) if @template.save
  end

  def show
    authorize @template

    if current_user.hr_or_above?
      redirect_to edit_interview_form_path(@template)
    end
  end

  def edit
    authorize @template
  end

  def update
    authorize @template
    @template.update(template_params)
    respond_to do |format|
      format.html {interview_form_path(template)}
      format.js
    end
  end

  def duplicate
    authorize @template
    new_template = InterviewForm.new(@template.attributes.except("id", "created_at", "updated_at"))
    new_template.title = new_template.title + ' - Duplicate'
    new_template.save
    @template.interview_form_tags.each do |tag|
      InterviewFormTag.create(tag_id: tag.tag_id, tag_name: tag.tag_name, interview_form_id: new_template.id)
    end
    i = 1
    @template.interview_questions.order(position: :asc).each do |question|
      new_question = InterviewQuestion.new(question.attributes.except("id", "created_at", "updated_at", "interview_form_id"))
      new_question.position = i
      new_question.interview_form_id = new_template.id
      new_question.save
      i += 1
    end
    redirect_to interview_form_path(new_template)
  end

  def interview_form_link_tags
    @template = InterviewForm.find(params[:add_tags][:form_id])
    authorize @template
    selected_tags = params[:interview_form][:tags].reject{|x| x.empty?}.join(',').split(',')
    selected_tags.each do |tag|
      unless InterviewFormTag.where(interview_form_id: @template.id, tag_id: tag).present?
        InterviewFormTag.create(interview_form_id: @template.id, tag_id: tag, tag_name: Tag.find(tag).tag_name)
      end
    end
    InterviewFormTag.where(interview_form_id: @template.id).where.not(tag_id: selected_tags).destroy_all
    respond_to do |format|
      format.js
    end
  end

  def destroy
    authorize @template
    @card_id = @template.id
    @template.destroy
    if ['show', 'edit'].include?(params[:page])
      redirect_to interview_forms_path
    else
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def set_template
    @template = InterviewForm.find(params[:id])
  end

  def template_params
    params.require(:interview_form).permit(:title, :description)
  end
end
