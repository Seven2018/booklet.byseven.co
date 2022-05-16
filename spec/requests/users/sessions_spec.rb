require 'rails_helper'

RSpec.describe "Users::Sessions request", type: :request do
  describe "GET /u/sign_in" do
    it 'should return 200' do
      get '/u/sign_in'
      expect(response).to have_http_status(:ok)
    end
  end
end
