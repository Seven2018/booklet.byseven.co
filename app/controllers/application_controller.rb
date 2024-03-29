require 'action_text'

class ApplicationController < ActionController::Base
  helper ActionText::Engine.helpers
  include Pundit

  protect_from_forgery with: :exception

  before_action :booklet_authenticate_user
  # before_action :authenticate_user!
  before_action :controller_action
  # before_action :set_time_zone, if: :user_signed_in?
  before_action :redirect_to_https

  # authentication_token system
  acts_as_token_authentication_handler_for User
  impersonates :user
  add_flash_types :error

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  SIZE_PAGE_INDEX = 20

  def redirect_to_https
    redirect_to :protocol => "https://" unless (request.ssl? || request.local? || Rails.env.testing? || Rails.env.development?)
  end

  if Rails.env.staging?
    http_basic_authenticate_with \
      name: ENV['STAGING_BASIC_AUTH_NAME'],
      password: ENV['STAGING_BASIC_AUTH_PWD']
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  protected

  def cancel_cache
    headers["Cache-Control"] = "no-cache, no-store, must-revalidate" # HTTP 1.1.
    headers["Pragma"] = "no-cache" # HTTP 1.0.
    headers["Expires"] = "0" # Proxies.
  end

  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page, # use collection.previous_page when using will_paginate
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def booklet_authenticate_user
    authenticate_user!
  end

  def authenticate_admin!
    redirect_to new_user_session_path unless current_user&.admin?
  end

  def redirect_unless_admin
    redirect_to root_path, notice: 'Espace réservé aux admins' unless current_user&.admin?
  end

  def ensure_company
    unless current_user.company
      flash[:alert] = "User must be associated to a company !"
      redirect_to root_path and return
    end
  end

  def controller_action
    @controller_action = [controller_name, action_name].join('_').to_sym
  end

  def show_navbar_admin
    @show_navbar_admin = true
  end

  def show_navbar_home
    @show_navbar_home = true
  end

  def show_navbar_training
    @show_navbar_training = true
  end

  def show_navbar_campaign
    # TODO rename _campaign => _interviews everywhere it's about the interviews application
    @show_navbar_campaign = true
  end

  def show_navbar_objective
    @show_navbar_objective = true
  end
end
