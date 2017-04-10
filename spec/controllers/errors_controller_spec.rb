# frozen_string_literal: true

require 'rails_helper'

describe ErrorsController do
  render_views

  describe '404' do
    subject { get(:show, params: { code: '404' }) }

    it { expect(subject.code).to eq('404') }
    it { expect(subject.body).to include("doesn't exist") }
  end

  describe '422' do
    subject { get(:show, params: { code: '422' }) }

    it { expect(subject.code).to eq('422') }
    it { expect(subject.body).to include('was rejected') }
  end

  describe '500' do
    subject { get(:show, params: { code: '500' }) }

    it { expect(subject.code).to eq('500') }
    it { expect(subject.body).to include('something went wrong') }
  end
end
