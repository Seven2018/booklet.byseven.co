require 'rails_helper'

RSpec.describe "Users::Sessions", type: :system do
  # before do
  #   driven_by(:rack_test)
  # end

  it '/u/sign_in Get sign in page' do
    visit '/u/sign_in'

    find("[name='user[email]']")
    # expect(page).to have_http_status(:ok)
  end
end
