require 'rails_helper'

describe OutputElementSerie do
  subject { described_class }

  it { is_expected.to respond_to(:contains) }
  it { is_expected.to respond_to(:gquery_contains) }

  describe '.new' do
    subject { described_class.new }

    # Relations
    it { is_expected.to respond_to(:output_element) }

    # Attributes
    it { is_expected.to respond_to(:output_element_key) }
    it { is_expected.to respond_to(:label) }
    it { is_expected.to respond_to(:color) }
    it { is_expected.to respond_to(:order_by) }
    it { is_expected.to respond_to(:group) }
    it { is_expected.to respond_to(:gquery) }
    it { is_expected.to respond_to(:show_at_first) }
    it { is_expected.to respond_to(:is_target_line) }
    it { is_expected.to respond_to(:target_line_position) }
    it { is_expected.to respond_to(:is_1990) }

    # methods
    it { is_expected.to respond_to(:title_translated) }
    it { is_expected.to respond_to(:group_translated) }
    it { is_expected.to respond_to(:json_attributes) }
    it { is_expected.to respond_to(:url_in_etengine) }
  end
end
