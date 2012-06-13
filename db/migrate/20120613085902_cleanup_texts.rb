class CleanupTexts < ActiveRecord::Migration
  class PageTitle < ActiveRecord::Base
    has_one :description, :as => :describable
  end

  def up
    rename_table :translations, :texts
    add_column :texts, :title_en, :string
    add_column :texts, :title_nl, :string
    add_column :texts, :short_content_en, :text
    add_column :texts, :short_content_nl, :text
    add_column :texts, :searchable, :boolean, :default => false

    Text.reset_column_information

    PageTitle.find_each do |p|
      key = "#{p.controller}_#{p.action}"

      I18n.locale = :en
      title_en = I18n.t!("page_titles.#{p.title.parameterize.underscore}") rescue nil

      I18n.locale = :nl
      title_nl = I18n.t!("page_titles.#{p.title.parameterize.underscore}") rescue nil

      t = Text.create :key => key,
        :title_en => title_en,
        :title_nl => title_nl,
        :short_content_en => p.description.try(:short_content_en),
        :short_content_nl => p.description.try(:short_content_nl),
        :content_en => p.description.try(:content_en),
        :content_nl => p.description.try(:content_nl),
        :searchable => true

      p.description.try :destroy
      p.destroy
    end

    drop_table :page_titles
  end

  def down
    rename_table :texts, :translations
    remove_column :translations, :title_en
    remove_column :translations, :title_nl
    remove_column :translations, :short_content_en
    remove_column :translations, :short_content_nl
    remove_column :translations, :searchable
  end
end
