# frozen_string_literal: true

require 'rails_helper'
require 'support/model_with_a_position_attribute'

describe SidebarItem do
  subject { described_class }

  it { is_expected.to respond_to(:ordered) }
  it { is_expected.to respond_to(:gquery_contains) }

  describe '.new' do
    subject { described_class.new }

    # Relations
    it { is_expected.to respond_to(:area_dependent) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:slides) }
    it { is_expected.to respond_to(:parent) }
    it { is_expected.to respond_to(:children) }
    it { is_expected.to respond_to(:tab) }

    # Attributes
    it { is_expected.to respond_to(:key) }
    it { is_expected.to respond_to(:section) }
    it { is_expected.to respond_to(:percentage_bar_query) }
    it { is_expected.to respond_to(:position) }
    it { is_expected.to respond_to(:parent_id) }

    # methods
    it { is_expected.to respond_to(:parsed_key_for_admin) }
    it { is_expected.to respond_to(:short_name) }


    describe ".tab" do
      subject { SidebarItem.all.first }
      it "returns a tab" do
        expect(subject.tab).to be_a Tab
      end
    end

    describe ".where" do
      subject { SidebarItem.where( tab_key: "overview" ) }

      it "only includes on sidebaritem" do
        expect(subject.count).to eq(1)
      end
    end
  end
end
