# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Survey::RangeQuestion do
  let(:question) do
    described_class.new(:text_question)
  end

  it 'coerces "0" as 1' do
    expect(question.coerce_value('0')).to eq(1)
  end

  it 'coerces "1" as 1' do
    expect(question.coerce_value('1')).to eq(1)
  end

  it 'coerces 1 as 1' do
    expect(question.coerce_value(1)).to eq(1)
  end

  it 'coerces "2" as 2' do
    expect(question.coerce_value('2')).to eq(2)
  end

  it 'coerces "5" as 5' do
    expect(question.coerce_value('5')).to eq(5)
  end

  it 'coerces "6" as 5' do
    expect(question.coerce_value('6')).to eq(5)
  end

  it 'coerces nil as nil' do
    expect(question.coerce_value(nil)).to be_nil
  end

  it 'coerces "" as nil' do
    expect(question.coerce_value('')).to be_nil
  end
end
