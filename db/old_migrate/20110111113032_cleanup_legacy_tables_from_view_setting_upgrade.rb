# == Schema Information
#
# Table name: input_elements
#
#  id                        :integer(4)      not null, primary key
#  name                      :string(255)
#  share_group               :string(255)
#  start_value_gql           :string(255)
#  min_value_gql             :string(255)
#  max_value_gql             :string(255)
#  min_value                 :float
#  max_value                 :float
#  start_value               :float
#  keys                      :text
#  attr_name                 :string(255)
#  step_value                :decimal(4, 2)
#  created_at                :datetime
#  updated_at                :datetime
#  update_type               :string(255)
#  unit                      :string(255)
#  factor                    :float
#  input_element_type        :string(255)
#  label                     :string(255)
#  comments                  :text
#  update_value              :string(255)
#  interface_group           :string(255)
#  update_max                :string(255)
#  locked_for_municipalities :boolean(1)
#  label_query               :string(255)
#
#  complexity                :integer(4)      default(1)
#  order_by                  :float
#  slide_id                  :integer(4)

# == Schema Information
#
# Table name: slides
#
#  id                        :integer(4)      not null, primary key
#  controller_name           :string(255)
#  action_name               :string(255)
#  name                      :string(255)
#  image                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  sub_header                :string(255)
#  sub_header2               :string(255)
#
#  default_output_element_id :integer(4)
#  complexity                :integer(4)      default(1)
#  order_by                  :integer(4)


# == Schema Information
#
# Table name: sidebar_items
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(255)
#  key                  :string(255)
#  section              :string(255)
#  percentage_bar_query :text
#  order_by             :integer(4)
#  created_at           :datetime
#  updated_at           :datetime
#

class CleanupLegacyTablesFromViewSettingUpgrade < ActiveRecord::Migration
  def self.up
    # remove_column :input_elements, :order_by
    # remove_column :input_elements, :complexity
    # remove_column :input_elements, :slide_id
    # 
    # remove_column :slides, :complexity
    # remove_column :slides, :order_by
    # remove_column :slides, :default_output_element_id
    # 
    # remove_column :sidebar_items, :order_by
  end

  def self.down
    # add_column :sidebar_items, :order_by, :float
    # 
    # add_column :slides, :default_output_element_id, :integer
    # add_column :slides, :order_by, :float
    # add_column :slides, :complexity, :integer,                :default => 1
    # 
    # add_column :input_elements, :slide_id, :integer
    # add_column :input_elements, :complexity, :integer,        :default => 1
    # add_column :input_elements, :order_by, :float
  end
end
