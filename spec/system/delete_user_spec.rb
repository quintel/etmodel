require 'rails_helper'

# A spec which tests what happens when a user is delete mid-session.
RSpec.describe 'Deleting a user', type: :system, vcr: true do
  before do
    driven_by :rack_test
  end

  let(:user) do
    create(:user)
  end

  it 'signs the user out' do
    VCR.use_cassette('deleting_user/signs_out') do
      mock_omniauth_user_sign_in(id: user.id, email: user.email, name: user.name)

      visit '/'
      click_button 'Log in'

      expect(page).to have_css('#my-account-button', text: user.name)
      expect(page).not_to have_css('.user-settings .sign-in', text: 'Log in')

      user.destroy

      visit '/'

      expect(page).not_to have_css('#my-account-button')
      expect(page).to have_css('.user-settings .sign-in', text: 'Log in')
    end
  end
end
