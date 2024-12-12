# frozen_string_literal: true

# Serializes a list of results which have been paginated by Pagy.
class PaginationSerializer
  extend Dry::Initializer

  option :pagy
  option :collection
  option :serializer
  option :url_for

  def as_json(*)
    {
      links: {
        first: @url_for.call(1, @pagy.vars[:limit]),
        prev: prev_link,
        next: next_link,
        last: @url_for.call(@pagy.last, @pagy.vars[:limit])
      },
      meta: {
        limit: @pagy.vars[:limit],
        count: @collection.size,
        total: @pagy.count,
        current_page: @pagy.page,
        total_pages: @pagy.pages
      },
      data: @collection.map { |item| @serializer.call(item).as_json }
    }
  end

  private

  def prev_link
    @url_for.call(@pagy.prev, @pagy.vars[:limit]) if @pagy.prev
  end

  def next_link
    @url_for.call(@pagy.next, @pagy.vars[:limit]) if @pagy.next
  end
end
