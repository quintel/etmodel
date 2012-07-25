class StoreColorHexValues < ActiveRecord::Migration
  def self.up
    OutputElementSerie.all.each do |o|
      hex = Colors::COLORS[o.color] || o.color
      o.color = hex
      o.save
    end
  end

  def self.down
  end
end
