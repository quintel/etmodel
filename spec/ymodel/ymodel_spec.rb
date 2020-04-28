# frozen_string_literal: true

require 'rails_helper'
# This file shouldn't actually exist within the rails app since it tests the
# gem. It does exist here for two reasons:
#  1. It might assert some stuff about the application.
#  2. Moving the specs to the gem is a hassle.
# These cops are disables because it saves space and its just a spec.
# rubocop:disable Style/ClassAndModuleChildren
class YModel::Concrete < YModel::Base
  source_file 'spec/fixtures/ymodel/concrete.yml'

  # This class var is used in the intended way, to save state over multiple
  # instances.
  # rubocop:disable Style/ClassVars
  def spy
    @@spy ||= nil
  end

  def set_spy
    @@spy = true
  end

  def unset_spy
    @@spy = nil
  end
  # rubocop:enable Style/ClassVars
end

class YModel::InvalidConcrete < YModel::Base
  source_file 'spec/fixtures/ymodel/invalid_concrete.yml'
end

class YModel::Related < YModel::Base
  source_file 'spec/fixtures/ymodel/concrete.yml'
  has_many :concretes,
           class_name: YModel::Concrete,
           foreign_key: :concrete_relation_id
end

class YModel::RelatedOnKey < YModel::Base
  source_file 'spec/fixures/ymodel/concrete'
  index_on :key
end

# Is used to test compiling multiple yaml files into one model.
class YModel::Compiled < YModel::Base
  source_file 'spec/fixtures/ymodel/compiled'
end

class YModel::InvalidCompiled < YModel::Base
  source_file 'spec/fixtures/ymodel/invalid_compiled'
  index_on :key
end

class YModel::WithAttribute < YModel::Base
  source_file 'spec/fixtures/ymodel/concrete.yml'
  default_attribute "test_attribute", with: true
  default_attribute "position", with: 42
end
# rubocop:enable Style/ClassAndModuleChildren

# rubocop:disable RSpec/MultipleDescribes
describe YModel::Base do
  subject { described_class }

  it { is_expected.to be_a Class }
  it { is_expected.to respond_to :index_on }

  describe '#new' do
    subject { YModel::Concrete.new(id: 1) }

    it { is_expected.to respond_to :key }
    it { is_expected.to respond_to :id }
    it { is_expected.to respond_to :nl_vimeo_id }
    it { is_expected.to respond_to :en_vimeo_id }
    it { is_expected.to respond_to :position }

    it "doesn't set attributes that aren't present in the schema" do
      instance = YModel::Concrete.new(foo: 'bar', id: '1')
      expect(instance.instance_variable_get('@foo')).to be nil
    end
  end

  describe '.all' do
    subject { YModel::Concrete.all }

    it { is_expected.to all(be_a YModel::Concrete) }
  end

  describe '.find' do
    describe 'with an actual record' do
      subject { YModel::Concrete.find(1) }

      it { is_expected.to be_a YModel::Concrete }
    end

    describe 'with a nil as argument' do
      subject { YModel::Concrete.find(nil) }

      it { is_expected.to eq nil }
    end
  end

  def find_by
    describe 'with an actual record' do
      subject { YModel::Concrete.find_by(id: 1) }

      it { is_expected.to be_a YModel::Concrete }
    end
  end

  describe '.where' do
    subject do
      YModel::Concrete.where(key: 'overview',
                             en_vimeo_id: '',
                             nillable: nil)
    end

    it { is_expected.to be_a Array }
    it { is_expected.to eq [YModel::Concrete.find(1)] }

    describe 'with malicious params' do
      subject do
        YModel::Concrete.where!(key: 'overview',
                                en_vimeo_id: '',
                                nillable: nil,
                                set_spy: true)
      end

      it 'doesn\'t send non-whitelabeled schema attributes' do
        expect { subject }.not_to(change { YModel::Concrete.all.first.spy })
      end
    end
  end

  describe '.find_by_key' do
    describe 'with a symbol' do
      subject { YModel::Concrete.find_by_key(:overview) }

      it { is_expected.to be_a YModel::Concrete }
    end

    describe 'with a string' do
      subject { YModel::Concrete.find_by_key('overview') }

      it { is_expected.to be_a YModel::Concrete }
    end
  end

  describe '.find_by_key!' do
    describe 'with an existing key' do
      subject { YModel::Concrete.find_by_key!(:overview) }

      it { is_expected.to be_a YModel::Concrete }
    end

    describe 'with a nonexsisting key' do
      it 'raises an error' do
        expect { YModel::Concrete.find_by_key!(:nonexisting) }
          .to raise_error(YModel::RecordNotFound)
      end
    end
  end

  describe '.has_many' do
    it 'raises an error when called with both an ' \
       '`as` and a `foreign_key` option' do
      expect { YModel::Concrete.has_many(:foo, as: 'bar', foreign_key: :qux) }
        .to raise_error(YModel::UnacceptableOptionsError)
    end

    describe 'decorates instances with' do
      subject { YModel::Related.all.first }

      it { is_expected.to respond_to :concretes }
      it { is_expected.to(satisfy { |sub| sub.concretes.class == Array }) }
    end
  end

  describe 'With a missing source' do
    it "doesn't raise an error upon loading" do
      expect { YModel::InvalidConcrete }.not_to raise_error
    end

    describe '.all' do
      subject { YModel::InvalidConcrete.all }

      it 'raises an error upon querying' do
        expect { subject }.to raise_error YModel::SourceFileNotFound
      end
    end

    describe '.find' do
      subject { YModel::InvalidConcrete.find(1) }

      it 'raises an error upon querying' do
        expect { subject }.to raise_error YModel::SourceFileNotFound
      end
    end

    describe '.find_by' do
      subject { YModel::InvalidConcrete.find(1) }

      it 'raises an error upon querying' do
        expect { subject }.to raise_error YModel::SourceFileNotFound
      end
    end

    describe '.find_by_key' do
      subject { YModel::InvalidConcrete.find_by_key(:foo) }

      it 'raises an error upon querying' do
        expect { subject }.to raise_error YModel::SourceFileNotFound
      end
    end
  end

  describe 'attributes' do
    # Is data correctly loaded?
    subject { YModel::Concrete.find(2) }

    it 'has the correct key' do
      expect(subject.key).to eq 'demand'
    end

    it 'has the correct nl_vimeo_id' do
      expect(subject.nl_vimeo_id).to eq '19658877'
    end

    it 'has the correct en_video_id' do
      expect(subject.en_vimeo_id).to eq '20191812'
    end

    it 'has the correct position' do
      expect(subject.position).to eq 2
    end
  end

  describe '#attributes' do
    subject { YModel::Concrete.find(1).attributes }

    it 'returns a hash with all attributes contained within the record' do
      expect(subject).to eq(id: 1,
                            key: 'overview',
                            nl_vimeo_id: '',
                            en_vimeo_id: '',
                            position: 1,
                            nillable: nil,
                            concrete_relation_id: 2)
    end
  end

  describe '#attribute?' do
    it 'when the the attribute is included in its schema' do
      expect(YModel::Concrete.find(1)).to be_attribute('key')
    end

    it 'when the attribute is not included in its schema' do
      expect(YModel::Concrete.find(1)).not_to be_attribute('bar')
    end
  end
end

describe YModel::Schema do
  let(:schema) do
    described_class.new([{ 'key1' => 'value', 'key2' => 'value' },
                         { 'key1' => 'value', 'key3' => 'value' }])
  end

  describe 'attributes' do
    subject { schema.attributes }

    it { is_expected.to all(be_a Symbol) }

    it 'contains all keys' do
      expect(subject.count).to eq(3)
    end
  end

  describe '#<<' do
    it "adds an attribute" do
      expect{ schema << "foo" }
        .to change{ schema.attributes.count }.by 1
    end
  end
end

describe YModel::Dump do
  subject { described_class }

  it { is_expected.to respond_to :call }
end

describe YModel::Compiled do
  it 'contains a record from first.yml' do
    expect(described_class.find(1)).to be_a described_class
  end

  it 'contains a record from second.yml' do
    expect(described_class.find(2)).to be_a described_class
  end

  describe '.source_files' do
    it 'returns a listing of files in the source directory' do
      expect(described_class.source_files.to_set)
        .to eq(['spec/fixtures/ymodel/compiled/first.yml',
                'spec/fixtures/ymodel/compiled/second.yml'].to_set)
    end
  end
end

describe YModel::InvalidCompiled do
  subject { described_class }

  it 'raises duplicate index error' do
    expect { described_class.all }
      .to raise_error(YModel::DuplicateIndexError)
  end
end

describe YModel::WithAttribute do
  subject { described_class.new }

  it { is_expected.to respond_to :test_attribute }

  context "when adding a attribute that doesn't occur" do
    subject { described_class.new.test_attribute }
    it { is_expected.to eq true }

    it 'can be overloaded' do
      record =  described_class.new test_attribute: 'foo'
      expect(record.test_attribute).to eq 'foo'
    end
  end

  context 'when adding an attribute that does occur' do
    describe 'with a record that has the attribute' do
      subject { described_class.find(1).position }
      it { is_expected.to eq(1) }
    end

    describe "with a record that doesn't have the attribute" do
      subject { described_class.find(4) }

      it 'falls back to the default' do
        expect(subject.position).to eq(42)
      end
    end
  end
end

# rubocop:enable RSpec/MultipleDescribes
