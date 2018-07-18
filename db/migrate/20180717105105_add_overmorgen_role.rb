# frozen_string_literal: true

class AddOvermorgenRole < ActiveRecord::Migration[5.1]
  def up
    Role.create!(name: 'overmorgen')
  end

  def down
    Role.find_by_name('overmorgen').destroy!
  end
end
