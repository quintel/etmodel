# frozen_string_literal: true

# Contains methods dealing with the descriptions in YModel classes such as
# Slides and InputElements
module Describable
  def description_short_content
    t :short_content
  end

  def description_content
    t :content
  end

  def t(attr_name)
    lang = I18n.locale.to_s.split('-').first
    description["#{attr_name}_#{lang}"]&.html_safe
  end

  # Ugly!
  #
  def description_embeds_player?
    description_content&.include?('player') ||
      description_content&.include?('object')
  end

end
