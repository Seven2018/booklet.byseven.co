
class TagManagementComponent < ViewComponent::Base
  def initialize(company_tags:, form_tags:, toggle_path:)
    @company_tags = company_tags
    @form_tags = form_tags
    @toggle_path = toggle_path
  end
end