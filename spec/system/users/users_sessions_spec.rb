require 'rails_helper'

RSpec.describe "Users::Sessions", type: :system do
  before do
    driven_by(:rack_test)
  end

  it '/u/sign_in Get sign in page' do
    visit '/u/sign_in'

    expect(page).to have_http_status(:ok)
  end

  let(:user) {create(:user)}
  it 'should be able to create a session by connecting user' do
    visit '/u/sign_in'

    fill_in("user_email", with: user.email)
    click_button('Continue')
    fill_in("user_password", with: user.password)
    click_button('Sign in')
    find_all('[aria-labelledby="dropdownMenuLogout"]')
  end
end
