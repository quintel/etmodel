# == Schema Information
#
# Table name: descriptions
#
#  id               :integer          not null, primary key
#  content_en       :text
#  short_content_en :text
#  describable_id   :integer
#  describable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  content_nl       :text
#  short_content_nl :text
#

class Description < ActiveRecord::Base
  belongs_to :describable, polymorphic: true

  # REFACTOR: Validators

  def short_content
    t :short_content
  end

  def content
    t :content
  end

  def t(attr_name)
    lang = I18n.locale.to_s.split('-').first
    send("#{attr_name}_#{lang}")&.html_safe
  end

  def title
    s = if describable.respond_to?(:title_for_description)
      describable.title_for_description
    elsif describable.respond_to?(:title)
      describable.title
    else
      nil
    end
  end

  # Ugly!
  #
  def embeds_player?
    content&.include?("player")  || content&.include?("object")
  end

  # For loading multiple flowplayers classname is needed instead of id
  #
  def sanitize_embedded_player
    content&.gsub %(id="player"), %(class="player")
  end
end

