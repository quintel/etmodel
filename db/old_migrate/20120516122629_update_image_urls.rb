class UpdateImageUrls < ActiveRecord::Migration
  def up
    Description.find_each do |d|
      ['content_en', 'content_nl', 'short_content_en', 'short_content_nl'].each do |attr|
        old = d.send attr
        if old
          n = old.gsub('/images/', '/assets/')
          d.send "#{attr}=", n
        end
        d.save
      end
    end

    Translation.find_each do |d|
      ['content_en', 'content_nl'].each do |attr|
        old = d.send attr
        if old
          n = old.gsub('/images/', '/assets/')
          d.send "#{attr}=", n
        end
        d.save
      end
    end

  end

  def down
  end
end
