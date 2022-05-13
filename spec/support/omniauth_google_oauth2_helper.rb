module GoogleOauth2Helper

  def google_oauth2_mock
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      :provider => 'google_oauth2',
      :uid => '123456789',
      :info => {
        :name => 'Jon Doe',
        :email => 'jon.doe@gmail.com'
      },
      :credentials => {
        :token => 'token',
        :refresh_token => 'refresh token'
      }
    })
  end
end
