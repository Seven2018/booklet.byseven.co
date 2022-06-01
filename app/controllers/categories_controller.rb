class CategoriesController < ApplicationController

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
