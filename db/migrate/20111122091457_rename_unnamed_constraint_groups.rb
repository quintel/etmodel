class RenameUnnamedConstraintGroups < ActiveRecord::Migration
  FROM_TO = {
    :unnamed_group_one   => :energy_use,
    :unnamed_group_two   => :co2,
    :unnamed_group_three => :import,
    :unnamed_group_five  => :footprint,
    :unnamed_group_six   => :renewable,
  }
  def self.up
    FROM_TO.each do |from, to|
      constraint = Constraint.find_by_group(from.to_s)
      constraint.group = to.to_s
      constraint.save
    end
  end

  def self.down
    FROM_TO.each do |from, to|
      constraint = Constraint.find_by_group(to.to_s)
      constraint.group = from.to_s
      constraint.save
    end
  end
end