class SetFixedInputElements < ActiveRecord::Migration
  def self.up
    InputElement.where(' id IN ( 512,513,519,521,522,523,525,527,272,528,529,274,530,275,531,277,279,535,280,536,281,537,282,283,539,540,541,286,289,290,291,548,550,553,554,556,313,414,415,437,500)').each do |i|
      i.fixed = true
      i.save
    end
  end

  def self.down
  end
end
