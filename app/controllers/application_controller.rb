require 'action_text'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :booklet_authenticate_user
  # before_action :authenticate_user!
  before_action :store_location
  add_flash_types :error
  # before_action :set_time_zone, if: :user_signed_in?
  include Pundit
  helper ActionText::Engine.helpers

  # authentication_token system
  acts_as_token_authentication_handler_for User

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  module VideoHelper
    def embed_video(video_url)
      if video_url =~ /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/
        video_id = video_url.split("=")[1]
        content_tag(:iframe, nil, src: "//www.youtube.com/embed/#{video_id}", allowfullscreen: "allowfullscreen")
      elsif video_url =~ /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]loom+)\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/
        video_id = video_url.split("/").last
        content_tag(:iframe, nil, src: "//www.loom.com/embed/#{video_id}", allowfullscreen: "allowfullscreen")
      end
    end
  end


  protected

  def after_sign_in_path_for(resource)
    params[:redirect_to].present? ? params[:redirect_to] : campaigns_path
  end

  # def after_sign_out_path_for(resource)
  #   request.referrer
  # end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def booklet_authenticate_user
    if params[:redirect_to].present? && user_signed_in?
      redirect_to params[:redirect_to]
    else
      authenticate_user!
    end
  end

  def after_successful_token_authentication
    # Make the authentication token to be disposable - for example
    # renew_authentication_token!
    url = "/" + (params[:redirect_to] || '')
    redirect_to url
  end

  def store_location
    unless params[:controller] == "devise/sessions"
      url = params[:redirect_to] || ''
      session[:user_return_to] = url
    end
  end

  def stored_location_for(resource_or_scope)
    session[:user_return_to] || super
  end

  def after_sign_in_path_for(resource)
    # stored_location_for(resource) || root_path
    if params[:redirect_to].present?
      "/#{params[:redirect_to]}"
    elsif stored_location_for(resource).present?
      stored_location_for(resource)
    else
      root_path
    end
  end
  # def set_time_zone
  #   Time.zone = current_user.time_zone
  # end

  def authenticate_admin!
    redirect_to new_user_session_path unless current_user&.admin?
  end
end
