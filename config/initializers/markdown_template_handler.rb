# frozen_string_literal: true

# Renders .md view files using Markdown.
module MarkdownHandler
  def self.call(template, source)
    RDiscount.new(
      source,
      :autolink,
      :footnotes,
      :smart
    ).to_html.inspect + '.html_safe'
  end
end

ActionView::Template.register_template_handler(:md, MarkdownHandler)
