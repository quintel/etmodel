class AddSecurityOfSupplyConstraint < ActiveRecord::Migration
  def self.up
    Constraint.create(
      key:            'security_of_supply',
      name:           'Blackout hours',
      extended_title: 'Number of blackout hours per year',
      gquery_key:     'dashboard_security_of_supply',
      group:          'unnamed_group_three'
    )
  end

  def self.down
    Constraint.where(key: 'security_of_supply').first.destroy
  end
end
