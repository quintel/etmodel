# frozen_string_literal: true

# rubocop:disable Style/Documentation, Metrics/LineLength, Metrics/MethodLength
class RemoveInputElements < ActiveRecord::Migration[5.2]
  def up
    drop_table :input_elements
  end

  def down
    create_table 'input_elements', id: :integer, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci', force: :cascade do |t|
      t.string 'key', limit: 191
      t.string 'share_group'
      t.float 'step_value'
      t.float 'draw_to_min'
      t.float 'draw_to_max'
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string 'unit'
      t.boolean 'fixed'
      t.text 'comments'
      t.string 'interface_group'
      t.string 'command_type', limit: 191
      t.string 'related_node'
      t.integer 'slide_id'
      t.integer 'position'
      t.index ['command_type'], name: 'index_input_elements_on_command_type'
      t.index ['key'], name: 'unique api key', unique: true
      t.index ['position'], name: 'index_input_elements_on_position'
      t.index ['slide_id'], name: 'index_input_elements_on_slide_id'
    end
  end
end
# rubocop:enable   Style/Documentation, Metrics/LineLength, Metrics/MethodLength
