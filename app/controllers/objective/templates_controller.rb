class Objective::TemplatesController < ApplicationController
  before_action :show_navbar_objective

  skip_forgery_protection
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def index
  end

  def new
  end

  def create
  end
end
