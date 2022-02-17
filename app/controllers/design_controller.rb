class DesignController < ApplicationController
  before_action :redirect_unless_admin, unless: -> { Rails.env.development? }
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped
  layout 'design'

  def index; end
  def guidelines; end
end
