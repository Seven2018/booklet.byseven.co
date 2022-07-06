class CategoriesController < ApplicationController
  skip_forgery_protection
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def index
    categories = current_user.company.categories.where(kind: params.require(:kind))
    categories = categories.where('lower(title) LIKE ?', "%#{params[:title].downcase}%") if params[:title]

    render json: categories, status: :ok
  end

  def update
    tag_id = params.require(:id)
    args = params.permit(:group_category_id, :title)

    tag = Category.find(tag_id)

    if tag.update(args)
      head :ok
    else
      render json: {message: "Couldn't update group category"}, status: :unprocessable_entity
    end
  end

  def destroy
    tag_id = params.require(:id)
    tag = Category.find(tag_id)

    if tag.destroy
      head :ok
    else
      render json: {message: "Couldn't delete tag"}, status: :unprocessable_entity
    end
  end

  def groups
    kind = params.require(:kind)
    raise ActionController::BadRequest, 'bad parameter' unless GroupCategory.kinds.include?(kind.to_sym)

    render json: current_user.company.group_categories.of_kind(kind.to_sym).order(position: :desc), status: :ok
  end

  def new_group
    group_name = params.require(:name)
    kind = params.require(:kind)
    group = current_user.company.group_categories.create(name: group_name, kind: kind)

    if group.valid?
      head :ok
    else
      render json: group.errors.messages, status: :unprocessable_entity
    end
  end

  def from_campaign
    campaign = Campaign.find(params.require(:id))

    render json: campaign.categories, status: :ok
  end


  def from_template
    interview_form = InterviewForm.find(params.require(:id))

    render json: interview_form.categories, status: :ok
  end

  # Search from categories with autocomplete
  def categories_search
    skip_authorization

    if params[:search].present?
      @categories = Category.where(company_id: current_user.company_id).ransack(title_cont: params[:search]).result(distinct: true)
    else
      @categories = Category.where(company_id: current_user.company_id)
    end

    respond_to do |format|
      format.json {
        @users = @categories.limit(5)
      }
    end
  end

  def search_v2
    categories = current_user.company.categories.where(kind: params.require(:kind))
    categories = categories.ransack(title_cont: params[:search]).result(distinct: true) if params[:search].present?
    categories = categories.where.not(group_category_id: params[:except_group_category_id]) if params[:except_group_category_id].present?

    render json: categories, status: :ok
  end

end
