# frozen_string_literal: true

require 'rails_helper'

describe PagesController, vcr: true do
  render_views

  context 'with an IE11 user agent' do
    before do
      request.env['HTTP_USER_AGENT'] =
        'Mozilla/5.0 (Windows NT 10.0; Trident/7.0; rv:11.0) like Gecko'
      get :root
    end

    it 'redirects to the unsupported browser page' do
      expect(response).to redirect_to(unsupported_browser_path(location: '/'))
    end
  end

  context 'with an IE11 user agent with the allow_unsupported_browser param set' do
    before do
      request.env['HTTP_USER_AGENT'] =
        'Mozilla/5.0 (Windows NT 10.0; Trident/7.0; rv:11.0) like Gecko'
    end

    let(:req) { get(:root, params: { allow_unsupported_browser: true }) }

    it 'renders the page' do
      expect(req).to be_successful
    end

    it 'sets the "allow_unsupported_browser" session variable' do
      expect { req }.to change { session[:allow_unsupported_browser] }.from(nil).to(true)
    end
  end

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
      sign_in FactoryBot.create(:user)
      get :root
    end

    it 'does not have a link to the admin section' do
      expect(response.body).not_to have_css('.my-account li.admin')
    end
  end

  context 'when visiting as an admin' do
    before do
      sign_in FactoryBot.create(:admin)
      get :root
    end

    it 'has a link to the admin section' do
      expect(response.body).to have_css('.my-account li.admin')
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
    it 'does not have custom year values when the active scenario is for a normal year' do
      post :root, params: { area_code: 'nl', other_year: '2040' }
      get :root
      expect(response.body).to have_select('end_year', with_options: ['2040'])
    end

    it 'has custom year values when the active scenario is for a custom year' do
      post :root, params: { area_code: 'nl', other_year: '2034' }
      get :root

      expect(response.body).to have_select('end_year', with_options: ['2034'])
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
end
