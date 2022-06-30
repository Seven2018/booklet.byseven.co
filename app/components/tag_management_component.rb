
class TagManagementComponent < ViewComponent::Base
  def initialize(company_tags:, tags:, toggle_path:, remove_company_tag_path:, search_tag_path:, color:, background_color:, always_open: false)
    @company_tags = company_tags
    @tags = tags
    @toggle_path = toggle_path
    @remove_company_tag_path = remove_company_tag_path
    @search_tag_path = search_tag_path
    @color = color
    @background_color = background_color
    @always_open = always_open
  end
end
