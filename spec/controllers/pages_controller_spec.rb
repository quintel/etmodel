# frozen_string_literal: true

require 'rails_helper'

describe PagesController, vcr: true do
  render_views

  context 'with the preferred language "nl"' do
    before do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'nl'
      get :root
    end

    after { I18n.locale = I18n.default_locale }

    it 'loads in the NL locale' do
      expect(I18n.locale).to eq(:nl)
    end
  end

  context 'with the preferred language "en"' do
    before do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'en'
      get :root
    end

    after { I18n.locale = I18n.default_locale }

    it 'loads in the EN locale' do
      expect(I18n.locale).to eq(:en)
    end
  end

  context 'with the preferred language "de"' do
    before do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'de'
      get :root
    end

    after { I18n.locale = I18n.default_locale }

    it 'loads in the EN locale' do
      expect(I18n.locale).to eq(:en)
    end
  end

  context 'when visiting as a guest' do
    before { get :root }

    it 'does not have a link to the admin section' do
      expect(response.body).not_to have_css('#settings_menu li.admin')
    end
  end

  context 'when visiting as a signed-in user' do
    before do
      login_as FactoryBot.create(:user)
      get :root
    end

    it 'does not have a link to the admin section' do
      expect(response.body).not_to have_css('#settings_menu li.admin')
    end
  end

  context 'when visiting as an admin' do
    before do
      login_as FactoryBot.create(:admin)
      get :root
    end

    it 'has a link to the admin section' do
      expect(response.body).to have_css('#settings_menu li.admin')
    end
  end

  { 'nl' => 2030, 'de' => 2050 }.each do |country, year|
    describe "selecting #{country} #{year}" do
      before do
        post :root, params: { area_code: country, end_year: year }
      end

      specify { expect(response).to redirect_to(play_path) }
      specify { expect(session[:setting].end_year).to eq(year) }
      specify { expect(session[:setting].area_code).to eq(country) }
    end
  end

  describe 'custom year values' do
    # rubocop:disable RSpec/MultipleExpectations, Metrics/LineLength
    it 'does not have custom year values when the active scenario is for a normal year' do
      post :root, params: { area_code: 'nl', other_year: '2040' }
      get :root
      expect(response.body).to have_selector('#new-scenario form') do |form|
        expect(form).to have_selector('select', name: 'end_year') do |field|
          expect(field).not_to have_selector('option', value: '2034')
          expect(field).to have_selector('option',
                                         value: '2040',
                                         selected: 'selected')
        end
      end
    end
    # rubocop:enable RSpec/MultipleExpectations, Metrics/LineLength

    # rubocop:disable RSpec/MultipleExpectations
    it 'has custom year values when the active scenario is for a custom year' do
      post :root, params: { area_code: 'nl', other_year: '2034' }
      get :root

      expect(response.body).to have_selector('#new-scenario form') do |form|
        expect(form).to have_selector('select', name: 'end_year') do |field|
          expect(field).to have_selector('option',
                                         value: '2034',
                                         selected: 'selected')
        end
      end
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  context 'when visiting static pages' do
    %i[bugs units browser_support disclaimer
       privacy_statement].each do |page|
      describe "#{page} page" do
        # rubocop:disable RSpec/MultipleExpectations
        it 'works' do
          get page
          expect(response).to be_successful
          expect(response).to render_template(page)
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end
  end

  context 'with a valid locale setting' do
    subject do
      put :set_locale, params: { locale: 'nl' }
      response
    end

    after { I18n.locale = I18n.default_locale }

    it { is_expected.to be_successful }
    it { expect { subject }.to change(I18n, :locale).from(:en).to(:nl) }
  end

  context 'with an invalid locale setting' do
    subject do
      put :set_locale, params: { locale: 'nl1212' }
      response
    end

    it { is_expected.to be_successful }
    it { expect { subject }.not_to change(I18n, :locale) }
  end

  context 'with hidden setting pages' do
    %i[show_all_countries show_flanders].each do |p|
      # rubocop:disable  RSpec/MultipleExpectations
      describe "pages##{p}" do
        it 'updates the session variable and redirect to home page' do
          get p
          expect(session[p]). to be(true)
          expect(response).to redirect_to(root_path)
        end
      end
      # rubocop:enable  RSpec/MultipleExpectations
    end
  end

  describe '#feedback' do
    subject do
      get :feedback, xhr: true
      response
    end

    it { is_expected.to be_successful }
    it { is_expected.to render_template(:feedback) }

    # rubocop:disable  RSpec/MultipleExpectations
    it 'lets the user post some feedback and send an email' do
      ActionMailer::Base.deliveries = []
      post :feedback, xhr: true, params: { feedback: {
        name: 'Schwarzenegger',
        email: 'arnold@quintel.com',
        msg: "I'll be back"
      }, format: :js }

      expect(response).to be_successful
      expect(response).to render_template(:feedback)
      emails = ActionMailer::Base.deliveries
      expect(emails.size).to be(1)
      quintel = emails.first
      expect(quintel.to[0]).to eql('info@quintel.com')
    end
    # rubocop:enable  RSpec/MultipleExpectations
  end

  describe 'whats new' do
    it 'renders an h1' do
      # Assert markdown rendering works
      get :whats_new
      expect(response.body).to have_css('.whats_new h1', text: /what’s new/i)
    end
  end
end
