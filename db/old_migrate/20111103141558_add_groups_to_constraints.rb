class AddGroupsToConstraints < ActiveRecord::Migration
  KEY_TO_GROUP = {
    total_primary_energy: 'unnamed_group_one',
    co2_reduction:        'unnamed_group_two',
    net_energy_import:    'unnamed_group_three',
    total_energy_cost:    'costs',
    not_shown:            'unnamed_group_five',
    renewable_percentage: 'unnamed_group_six',
    targets_met:          'summary',
    score:                'summary',
  }.with_indifferent_access

  def self.up
    add_column :constraints, :group, :string, limit: 25, null: false

    Constraint.all.each do |constraint|
      unless group = KEY_TO_GROUP[constraint.key]
        raise "No key -> group mapping for #{constraint.key}, add one in" \
              "the 'add_groups_to_constraints' migration."
      end

      constraint.update_attributes(group: group)
    end
  rescue Exception => e
    down
    raise e
  end

  def self.down
    remove_column :constraints, :group
  end
end
