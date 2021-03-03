# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Survey::TextQuestion do
  let(:question) do
    described_class.new(:text_question)
  end

  it 'does not coerce "Hello"' do
    expect(question.coerce_value('Hello')).to eq('Hello')
  end

  it 'truncates values longer than 8196 characters' do
    expect(question.coerce_value('a' * 9000).length).to eq(8192)
  end

  it 'coerces "" into ""' do
    expect(question.coerce_value('')).to eq('')
  end

  it 'coerces "  " into ""' do
    expect(question.coerce_value('  ')).to eq('')
  end

  it 'coerces nil into nil' do
    expect(question.coerce_value(nil)).to be_nil
  end
end
