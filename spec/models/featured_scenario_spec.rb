# frozen_string_literal: true

require 'rails_helper'

describe FeaturedScenario do
  describe 'associations' do
    it { is_expected.to belong_to(:saved_scenario) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:saved_scenario_id) }
    it { is_expected.to validate_presence_of(:description_en) }
    it { is_expected.to validate_presence_of(:description_nl) }
    it { is_expected.to validate_presence_of(:title_en) }
    it { is_expected.to validate_presence_of(:title_nl) }
    it { is_expected.to validate_inclusion_of(:group).in_array(FeaturedScenario::GROUPS) }

    it 'validates that the saved_scenario_id is unique' do
      fs = FactoryBot.create(:featured_scenario)
      expect(fs).to validate_uniqueness_of(:saved_scenario_id)
    end
  end

  describe '.in_groups with order one, two, three, :rest, nil' do
    let(:defaults) { { group: nil, title: nil } }

    let(:group_one) do
      [
        FactoryBot.build(
          :featured_scenario,
          group: 'one',
          saved_scenario: FactoryBot.build(:saved_scenario, title: 'A')
        ),
        FactoryBot.build(
          :featured_scenario,
          group: 'one',
          saved_scenario: FactoryBot.build(:saved_scenario, title: 'B')
        ),
        FactoryBot.build(
          :featured_scenario,
          group: 'one',
          saved_scenario: FactoryBot.build(:saved_scenario, title: 'Z')
        )
      ]
    end

    let(:group_two) do
      [
        FactoryBot.build(:featured_scenario, group: 'two'),
        FactoryBot.build(:featured_scenario, group: 'two')
      ]
    end

    let(:group_three) { [FactoryBot.build(:featured_scenario, group: 'three')] }
    let(:group_four) { [FactoryBot.build(:featured_scenario, group: 'four')] }
    let(:group_five) { [FactoryBot.build(:featured_scenario, group: 'five')] }
    let(:group_nil) { [FactoryBot.build(:featured_scenario, group: nil)] }

    let(:unsorted) do
      [
        group_one[2],
        group_three[0],
        group_five[0],
        group_two[0],
        group_nil[0],
        group_two[1],
        group_one[0],
        group_four[0],
        group_one[1]
      ]
    end

    let(:order) { ['one', 'two', 'three', :rest, nil] }

    let(:ordered) { described_class.in_groups(unsorted, order) }

    it 'creates an entry per group, ordered as in the parameters' do
      expect(ordered.map { |group| group[:name] })
        .to eq(['one', 'two', 'three', 'five', 'four', nil])
    end

    describe 'the "one" group' do
      it 'has scenarios which belong to the "one" group' do
        expect(ordered[0][:scenarios]).to eq(group_one)
      end
    end

    describe 'the "two" group' do
      it 'has scenarios which belong to the "two" group' do
        expect(ordered[1][:scenarios]).to eq(group_two)
      end
    end

    describe 'the "three" group' do
      it 'has scenarios which belong to the "three" group' do
        expect(ordered[2][:scenarios]).to eq(group_three)
      end
    end

    describe 'the "five" group' do
      it 'has scenarios which belong to the "five" group' do
        expect(ordered[3][:scenarios]).to eq(group_five)
      end
    end

    describe 'the "four" group' do
      it 'has scenarios which belong to the "four" group' do
        expect(ordered[4][:scenarios]).to eq(group_four)
      end
    end

    it 'places ungrouped scenarios last' do
      expect(ordered[5][:scenarios]).to eq(group_nil)
    end
  end
end
