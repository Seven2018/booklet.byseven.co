class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user&.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'

      image = request.env['omniauth.auth'].info.image

      @user.update(picture: image)

      sign_in_and_redirect @user, event: :authentication
    else
      flash[:alert] = I18n.t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: 'errors were encountered'
      redirect_to(root_path)
    end
  end

  # # Linkedin Auth (not used atm)
  # def linkedin
  #   @user = User.from_omniauth(request.env['omniauth.auth'])

  #   if @user.persisted?
  #     flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Linkedin'
  #     sign_in_and_redirect @user, event: :authentication
  #   else
  #     session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
  #     redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
  #   end
  # end
end
