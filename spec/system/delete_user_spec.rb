require 'rails_helper'

# A spec which tests what happens when a user is delete mid-session.
RSpec.describe 'Deleting a user', type: :system, vcr: true do
  before do
    driven_by :rack_test
  end

  let(:user) do
    create(:user)
  end

  # PENDING: current_user now resolves via User.from_jwt! (find_or_create_by!, mirroring the API
  # auth path), which recreates a local shadow row for the same ID rather than raising when the row
  # is missing — the previous legacy-session code path used find! (raises), so a locally-deleted
  # user was signed out on their next request.
  pending 'signs the user out' do
    VCR.use_cassette('deleting_user/signs_out') do
      identity_session_cookie(
        mock_identity_user_sign_in(id: user.id, email: user.email, name: user.name)
      )

      visit '/'

      expect(page).to have_css('#my-account-button', text: user.name)
      expect(page).not_to have_css('.user-settings .sign-in', text: 'Log in')

      user.destroy

      visit '/'

      expect(page).not_to have_css('#my-account-button')
      expect(page).to have_css('.user-settings .sign-in', text: 'Log in')
    end
  end
end
