#  create_table "input_elements", :force => true do |t|
#    t.string   "name"
#    t.string   "key"
#    t.text     "keys"
#    t.string   "attr_name"
#    t.integer  "slide_id"
#    t.string   "share_group"
#    t.string   "start_value_gql"
#    t.string   "min_value_gql"
#    t.string   "max_value_gql"
#    t.float    "min_value"
#    t.float    "max_value"
#    t.float    "start_value"
#    t.float    "order_by"
#    t.decimal  "step_value",                :precision => 4, :scale => 2
#    t.datetime "created_at"
#    t.datetime "updated_at"
#    t.string   "update_type"
#    t.string   "unit"
#    t.float    "factor"
#    t.string   "input_element_type"
#    t.string   "label"
#    t.text     "comments"
#    t.string   "update_value"
#    t.integer  "complexity",                                              :default => 1
#    t.string   "interface_group"
#    t.string   "update_max"
#    t.boolean  "locked_for_municipalities"
#    t.string   "label_query"
#    t.integer  "input_id"
#  end
  
class RemoveUnusedInputElementsColumns < ActiveRecord::Migration
  def self.up
    %w[
      keys 
      attr_name 
      start_value_gql 
      start_value 
      min_value 
      min_value_gql 
      max_value 
      max_value_gql
      update_max
      label_query
      update_value
    ].each do |attr_name|
      remove_column :input_elements, attr_name
    end
  end

  def self.down
  end
end
