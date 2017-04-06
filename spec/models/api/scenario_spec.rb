require 'rails_helper'

describe Api::Scenario do
  let(:defaults) { { ordering: nil, title: nil } }

  let(:unsorted) { [
    Api::Scenario.new(display_group: 'one', ordering: 1, title: 'Z'),
    Api::Scenario.new(defaults.merge(display_group: 'three')),
    Api::Scenario.new(defaults.merge(display_group: 'two')),
    Api::Scenario.new(defaults.merge(display_group: 'five')),
    Api::Scenario.new(defaults.merge(display_group: 'two')),
    Api::Scenario.new(defaults.merge(display_group: nil)),
    Api::Scenario.new(defaults.merge(display_group: 'one', title: 'A')),
    Api::Scenario.new(defaults.merge(display_group: 'four')),
    Api::Scenario.new(defaults.merge(display_group: 'one', title: 'B'))
  ] }

  describe 'with order one, two, three, :rest, nil' do
    let(:order) { [
      'one', 'two', 'three', :rest, nil
    ] }

    let(:ordered) { Api::Scenario.in_groups(unsorted, order) }

    it 'places "one" scenarios first' do
      expect(ordered[0][:name]).to eq('one')
      expect(ordered[0][:scenarios].length).to eq(3)

      expect(ordered[0][:scenarios].map(&:display_group)).to eq(['one'] * 3)
    end

    it 'places "two" scenarios second' do
      expect(ordered[1][:name]).to eq('two')
      expect(ordered[1][:scenarios].length).to eq(2)

      expect(ordered[1][:scenarios].map(&:display_group)).to eq(['two'] * 2)
    end

    it 'places "three" scenarios second' do
      expect(ordered[2][:name]).to eq('three')
      expect(ordered[2][:scenarios].length).to eq(1)

      expect(ordered[2][:scenarios].map(&:display_group)).to eq(['three'])
    end

    it 'places un-specified grouped next' do
      expect(ordered[3][:name]).to eq('five')
      expect(ordered[3][:scenarios].length).to eq(1)

      expect(ordered[3][:scenarios].map(&:display_group)).to eq(['five'])

      expect(ordered[4][:name]).to eq('four')
      expect(ordered[4][:scenarios].length).to eq(1)

      expect(ordered[4][:scenarios].map(&:display_group)).to eq(['four'])
    end

    it 'places ungrouped scenarios last' do
      expect(ordered[5][:name]).to eq(nil)
      expect(ordered[5][:scenarios].length).to eq(1)

      expect(ordered[5][:scenarios].map(&:display_group)).to eq([nil])
    end

    it 'orders scenarios within the groups' do
      expect(ordered[0][:scenarios].map(&:ordering)).to eq([1, nil, nil])
      expect(ordered[0][:scenarios].map(&:title)).to eq(%w( Z A B ))
    end
  end # with order one, two, three, :rest, nil
end # Api::Scenario
