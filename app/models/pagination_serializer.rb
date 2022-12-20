# frozen_string_literal: true

# Serializes a list of results which have been paginated by Kaminari.
class PaginationSerializer
  extend Dry::Initializer

  option :collection
  option :serializer
  option :url_for

  def as_json(*)
    {
      links: {
        first: @url_for.call(1, @collection.limit_value),
        prev: prev_link,
        next: next_link,
        last: @url_for.call(@collection.total_pages, @collection.limit_value)
      },
      meta: {
        limit: @collection.limit_value,
        count: @collection.count,
        total: @collection.total_count,
        current_page: @collection.current_page,
        total_pages: @collection.total_pages
      },
      data: @collection.map { |item| @serializer.call(item).as_json }
    }
  end

  private

  def prev_link
    @url_for.call(@collection.prev_page, @collection.limit_value) if @collection.prev_page
  end

  def next_link
    @url_for.call(@collection.next_page, @collection.limit_value) if @collection.next_page
  end
end
