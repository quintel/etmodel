# frozen_string_literal: true

require 'rails_helper'
require 'pagy/extras/array'

RSpec.describe PaginationSerializer do
  context 'with a collection of 3 items' do
    let(:collection) do
      [
        { id: 1, name: 'Foo' },
        { id: 2, name: 'Bar' },
        { id: 3, name: 'Baz' }
      ]
    end

    let(:json) do
      described_class.new(
        pagy: pagy,
        collection: paginated,
        serializer: ->(item) { item },
        url_for: ->(page, limit) { "/objects?page=#{page}&limit=#{limit}" }
      ).as_json
    end

    context 'with page=1 and limit=2' do
      let(:pagy) do
        Pagy.new(count: collection.size, page: 1, limit: 2)
      end

      let(:paginated) do
        collection.slice(pagy.offset, pagy.vars[:limit])
      end

      it 'includes the serialized records' do
        expect(json[:data]).to eq([
          collection[0].as_json,
          collection[1].as_json
        ])
      end

      it 'includes a link to the first page' do
        expect(json[:links][:first]).to eq('/objects?page=1&limit=2')
      end

      it 'does not include a link to the previous page' do
        expect(json[:links][:prev]).to be_nil
      end

      it 'includes a link to the next page' do
        expect(json[:links][:next]).to eq('/objects?page=2&limit=2')
      end

      it 'includes a link to the last page' do
        expect(json[:links][:last]).to eq('/objects?page=2&limit=2')
      end

      it 'has a count of 2' do
        expect(json[:meta][:count]).to eq(2)
      end

      it 'has a total of 3' do
        expect(json[:meta][:total]).to eq(3)
      end

      it 'has a limit of 2' do
        expect(json[:meta][:limit]).to eq(2)
      end

      it 'has a total_pages of 2' do
        expect(json[:meta][:total_pages]).to eq(2)
      end

      it 'has a current_page of 1' do
        expect(json[:meta][:current_page]).to eq(1)
      end
    end

    context 'with page=2 and limit=2' do
      let(:pagy) do
        Pagy.new(count: collection.size, page: 2, limit: 2)
      end

      let(:paginated) do
        collection.slice(pagy.offset, pagy.vars[:limit])
      end

      it 'includes the serialized records' do
        expect(json[:data]).to eq([
          collection[2].as_json
        ])
      end

      it 'includes a link to the first page' do
        expect(json[:links][:first]).to eq('/objects?page=1&limit=2')
      end

      it 'includes a link to the previous page' do
        expect(json[:links][:prev]).to eq('/objects?page=1&limit=2')
      end

      it 'does not include a link to the next page' do
        expect(json[:links][:next]).to be_nil
      end

      it 'includes a link to the last page' do
        expect(json[:links][:last]).to eq('/objects?page=2&limit=2')
      end

      it 'has a count of 1' do
        expect(json[:meta][:count]).to eq(1)
      end

      it 'has a total of 3' do
        expect(json[:meta][:total]).to eq(3)
      end

      it 'has a limit of 2' do
        expect(json[:meta][:limit]).to eq(2)
      end

      it 'has a total_pages of 2' do
        expect(json[:meta][:total_pages]).to eq(2)
      end

      it 'has a current_page of 2' do
        expect(json[:meta][:current_page]).to eq(2)
      end
    end
  end
end
