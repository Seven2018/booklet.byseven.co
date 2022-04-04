# frozen_string_literal: true

class ImpersonationsController < ApplicationController
  before_action :verify_user_is_admin
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    @users = User.where(user_params)
                 .limit(limit).offset(offset)
                 .order(created_at: :desc)
    @total_pages = (User.count.to_f / limit).to_i
  end


  def impersonate
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to after_sign_in_path_for(user)
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end

  private

  def verify_user_is_admin
    redirect_to root_path, notice: 'Espace réservé aux admins' unless true_user.admin? || current_user.admin?
  end

  def user_params
    {
      company_id: params[:company_id],
      firstname: params[:firstname],
      lastname: params[:lastname],
      email: params[:email],
      access_level: params[:access_level]
    }.compact
  end

  def limit
    30
  end

  def offset
    params[:page].to_i * limit
  end
end
