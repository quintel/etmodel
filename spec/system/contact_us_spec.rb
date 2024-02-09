# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'The contact us form', type: :system do
  before do
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end

  pending 'sends a message when all params are provided' do
    visit '/contact'

    fill_in 'Name', with: 'My name'
    fill_in 'E-mail', with: 'my-email@example.org'
    fill_in 'Message', with: 'My message'

    click_button 'Send message'

    expect(page).to have_text('Thank you for your message')
  end

  pending 'shows an error when the params are missing' do
    visit '/contact'

    click_button 'Send message'

    expect(page).not_to have_text("Name can't be blank")
    expect(page).to have_text("E-mail can't be blank")
    expect(page).to have_text("Message can't be blank")
  end
end
