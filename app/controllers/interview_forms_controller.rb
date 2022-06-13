class InterviewFormsController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :duplicate, :destroy, :toggle_tag, :remove_company_tag, :search_tags, :index_line]
  before_action :show_navbar_campaign

  skip_forgery_protection

  def index

    policy_scope(InterviewForm)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def list
    interviewForms = InterviewForm.unused.where(company: current_user.company)
    interviewForms = interviewForms.search_templates(params[:title]) if params[:title].present?
    interviewForms = interviewForms.order(created_at: :desc)


    page = params[:page] && params[:page][:number] ? params[:page][:number] : 1
    size = params[:page] && params[:page][:size] ? params[:page][:size] : 10
    interviewForms = interviewForms.page(page).per(size)

    authorize interviewForms

    render json: interviewForms, meta: pagination_dict(interviewForms)
  end

  def create
    @template = InterviewForm.new template_params.merge(company: current_user.company)
    authorize @template
    redirect_to edit_interview_form_path(@template) if @template.save
  end

  def show
    authorize @template
  end

  def edit
    authorize @template
    @tags = @template.categories.order(title: :asc).pluck(:title)
    @company_tags = Category
                      .where(company_id: current_user.company_id, kind: :interview)
                      .where.not(title: @tags)
                      .pluck(:title)
  end

  def update
    authorize @template
    description = @template.description
    @template.update(template_params)

    @update_description =
      params.dig(:interview_form, :description).present? || false

    unless @update_description
      cross_status =
        params.dig(:interview_form, :cross).present? && @template.answerable_by_both?
      @template.update(cross: cross_status)

      answerable_by_status = @template.answerable_by
      unless @template.answerable_by_both?
        @template.interview_questions.update_all(visible_for: answerable_by_status)
        @template.interview_questions.where.not(required_for: ['none', answerable_by_status]).update_all(required_for: answerable_by_status)
      end
    end

    respond_to do |format|
      format.html { interview_form_path(@template) }
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

  def destroy
    authorize @template
    @card_id = @template.id
    @template.destroy
    respond_to do |format|
      format.js
      format.json {head :ok}
    end
  end


  ###########################
  ## CATEGORIES MANAGEMENT ##
  ###########################

  def toggle_tag
    authorize @template
    tag = params.require(:tag)
    category = Category.find_by(company_id: current_user.company_id, title: tag, kind: :interview)

    if category.nil?
      new_category = Category.create(company_id: current_user.company_id, title: tag, kind: :interview)
      @template.categories << new_category
    else
      if @template.categories.exists?(category.id)
        @template.categories.delete(category)
      else
        @template.categories << category
      end
    end

    @displayed_tags = Category.where(company_id: current_user.company_id, kind: :interview)
                              .where_exists(:interview_forms)
                              .order(title: :asc)

    respond_to do |format|
      format.html {
        render partial: 'campaigns/index/index_campaigns_displayed_tags', locals: { displayed_tags: @displayed_tags }
      }
      format.json {head :ok}
    end
  end

  def remove_company_tag
    authorize @template
    tag = params.require(:tag)

    Category.where(company_id: current_user.company_id, title: tag, kind: :interview).destroy_all

    render partial: 'campaigns/index/index_campaigns_displayed_tags', locals: { displayed_tags: @displayed_tags }
  end

  def search_tags
    authorize @template
    input = params[:input]
    black_tags = InterviewForm.find(@template.id).categories.pluck(:title)
    tags = Category
             .where(company_id: current_user.company_id)
             .where.not(title: black_tags)
             .where('lower(title) LIKE ?', "%#{input.downcase}%")
             .order(title: :asc)
             .pluck(:title)

    render json: tags, root: 'categories', status: :ok
  end

  def index_line
    skip_authorization

    respond_to do |format|
      format.js
    end
  end

  ###########################

  # Search from templates with autocomplete
  def templates_search
    skip_authorization

    @templates =
      InterviewForm.unused.where(company_id: current_user.company_id)

    @templates = @templates.ransack(title_cont: params[:search]).result(distinct: true)

    respond_to do |format|
      format.html {}
      format.json {
        @templates
      }
    end
  end

  private

  def set_template
    @template = InterviewForm.find(params[:id])
  end

  def template_params
    params.require(:interview_form).permit(:title, :description, :video, :answerable_by, :cross)
  end
end
