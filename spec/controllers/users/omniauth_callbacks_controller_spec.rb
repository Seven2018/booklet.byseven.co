require 'rails_helper'
require 'support/omniauth_google_oauth2_helper'

RSpec.configure do |c|
  c.include GoogleOauth2Helper
end

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe 'POST #google_oauth2' do
    context 'unknown user' do
      subject { create(:user, email: 'nope@123.com') }
      it 'should redirect to root page' do
        OmniAuth.config.test_mode = true
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = google_oauth2_mock
        request_google = proc { post :google_oauth2, params: { provider: 'google_oauth2' } }
        expect(request_google.call).to redirect_to root_path
      end

      it 'should not get user with flash alert' do
        OmniAuth.config.test_mode = true
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = google_oauth2_mock
        request_google = proc { post :google_oauth2, params: { provider: 'google_oauth2' } }
        request_google.call
        expect(flash.now['alert']).to eq(I18n.t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: 'errors were encountered')
      end
    end

    context 'known user' do
      subject { create(:user) }
      it 'should get user and redirect to root page' do
        subject
        OmniAuth.config.test_mode = true
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = google_oauth2_mock
        request_google = proc { post :google_oauth2, params: { provider: 'google_oauth2' } }
        expect(request_google.call).to redirect_to root_path
      end

      it 'should get user' do
        subject
        OmniAuth.config.test_mode = true
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = google_oauth2_mock
        request_google = proc { post :google_oauth2, params: { provider: 'google_oauth2' } }
        request_google.call
        expect(flash.now['notice']).to eq(I18n.t 'devise.omniauth_callbacks.success', kind: 'Google')
      end
    end
  end
end
