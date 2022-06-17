class GroupCategoriesController < ApplicationController
  skip_forgery_protection
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def update
    id = params.require(:id)
    name = params.require(:name)
    group_category = GroupCategory.find(id)

    group_category.update(name: name) if group_category.name.downcase != 'others'
    head :ok
  end

  def destroy
    id = params.require(:id)
    group_category = GroupCategory.find(id)
    def_group_category = current_user.company.group_categories.default_group_for(group_category.kind)

    group_category.categories.update_all(group_category_id: def_group_category.id)
    if group_category.destroy
      head :ok
    else
      render json: {message: 'there has been an error'}, status: :unprocessable_entity
    end
  end
end
