class CategoriesController < ApplicationController
  skip_forgery_protection
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def index
    categories = current_user.company.categories.where(kind: params.require(:kind))
    categories = categories.where(title: params[:title]) if params[:title]

    render json: categories, status: :ok
  end

  def from_campaign
    campaign = Campaign.find(params.require(:id))

    render json: campaign.categories, status: :ok
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

end
