require 'action_text'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  add_flash_types :error
  # before_action :set_time_zone, if: :user_signed_in?
  include Pundit
  helper ActionText::Engine.helpers

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
    dashboard_path
  end

  # def after_sign_out_path_for(resource)
  #   request.referrer
  # end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  # def set_time_zone
  #   Time.zone = current_user.time_zone
  # end
end
