
class MobileMenuFieldComponent < ViewComponent::Base
  def initialize(title:, divider: true, class_name: '', class_name_logo: '', path:, method: :get)
    @title = title
    @divider = divider
    @class_name = class_name
    @class_name_logo = class_name_logo
    @path = path
    @method = method
  end
end