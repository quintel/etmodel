
module Describable
  def short_content
    t :short_content
  end

  def content
    t :content
  end

  def t(attr_name)
    lang = I18n.locale.to_s.split('-').first
    description["#{attr_name}_#{lang}"]&.html_safe
  end

  # Ugly!
  #
  def description_embeds_player?
    content&.include?("player")  || content&.include?("object")
  end

  # For loading multiple flowplayers classname is needed instead of id
  #
  def description_sanitize_embedded_player
    content&.gsub %(id="player"), %(class="player")
  end
end