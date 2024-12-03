# frozen_string_literal: true

require 'rails_helper'

describe FeaturedScenario do
  # TODO: refactor into dry to show on homepage

  pending 'validations' do
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

  pending '.in_groups with order one, two, three, :rest, nil' do
    let(:defaults) { { group: nil, title: nil } }

    let(:group_one) do
      [
        FactoryBot.build(:featured_scenario, group: 'one', title_en: 'A'),
        FactoryBot.build(:featured_scenario, group: 'one', title_en: 'B'),
        FactoryBot.build(:featured_scenario, group: 'one', title_en: 'C')
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

  pending '.in_groups_per_end_year' do
    let(:defaults) { { group: nil, title: nil } }

    let(:scenario_2050) { FactoryBot.build(:saved_scenario, end_year: 2050) }
    let(:scenario_2030) { FactoryBot.build(:saved_scenario, end_year: 2030) }

    let(:group_one) do
      [
        FactoryBot.build(:featured_scenario, group: 'one', title_en: 'A', saved_scenario: scenario_2030),
        FactoryBot.build(:featured_scenario, group: 'one', title_en: 'B', saved_scenario: scenario_2030),
        FactoryBot.build(:featured_scenario, group: 'one', title_en: 'C', saved_scenario: scenario_2050)
      ]
    end

    let(:group_two) do
      [
        FactoryBot.build(:featured_scenario, group: 'two', saved_scenario: scenario_2030),
        FactoryBot.build(:featured_scenario, group: 'two', saved_scenario: scenario_2050)
      ]
    end

    let(:unsorted) do
      [
        group_one[2],
        group_two[1],
        group_one[0],
        group_two[0],
        group_one[1]
      ]
    end

    let(:order) { ['one', 'two', :rest, nil] }

    let(:ordered) { described_class.in_groups_per_end_year(unsorted, order) }

    describe 'the 2030 group' do
      it 'has scenarios which belong to the "one" group' do
        expect(ordered[2030][0][:scenarios][0]).to be(group_one[0])
      end
      it 'has scenarios which belong to the "two" group' do
        expect(ordered[2030][1][:scenarios][0]).to be(group_two[0])
      end
    end

    describe 'the 2050 group' do
      it 'has scenarios which belong to the "one" group' do
        expect(ordered[2050][0][:scenarios][0]).to be(group_one[2])
      end
      it 'has scenarios which belong to the "two" group' do
        expect(ordered[2050][1][:scenarios][0]).to be(group_two[1])
      end
    end
  end
end
