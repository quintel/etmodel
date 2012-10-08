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
  has_paper_trail

  belongs_to :describable, :polymorphic => true

  # REFACTOR: Validators

  searchable do
    text :content_en
    text :content_nl
    text :short_content_en
    text :short_content_nl
  end

  def short_content
    t :short_content
  end

  def content
    t :content
  end

  def t(attr_name)
    lang = I18n.locale.to_s.split('-').first
    send("#{attr_name}_#{lang}").andand.html_safe
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

  def embeds_player?
    content.andand.include?("player")  || content.andand.include?("object")
  end
end

