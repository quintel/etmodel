# == Schema Information
#
# Table name: constraints
#
#  id             :integer(4)      not null, primary key
#  key            :string(255)
#  name           :string(255)
#  extended_title :string(255)
#  query          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  gquery_id      :integer(4)
#

# REFACTOR seb : this should probably belong within helpers
module ConstraintFormatter

  # each constraint has a unique output format
  def self.output(constraint)
    now = constraint.data.present_value
    future = constraint.data.future_value

    case constraint.key
      when :total_primary_energy
        Metric.performance_html(now, future)
      when :co2_reduction
        Metric.performance_html(Current.scenario.area.co2_emission_1990_billions, future)
      when :net_energy_import, :renewable_percentage
        Metric.percentage_html(future, :signed => false)
      when :total_energy_cost
        Metric.currency((future / BILLIONS))
      when :not_shown
        Metric.suffix(future.round(2), Metric.x_country(Current.scenario.country))
      when :targets_met
        Metric.out_of(future, Current.gql.policy.goals.length)
      when :score
        future.to_i
    end
  end
end

class Constraint < ActiveRecord::Base

  has_and_belongs_to_many :root_nodes
  belongs_to :gquery

  def key
    read_attribute(:key).to_sym
  end
  
  # TODO why is the formatting included here?? 
  def output
    ConstraintFormatter.output(self)
  end
  
  # Get the unformatted value of a contraint
  def unformatted_output
    now, future = [data.present_value, data.future_value]
    case self.key
      when :total_primary_energy
        (future - now) / now.to_f
      when :co2_reduction
        (future - Current.scenario.area.co2_emission_1990_billions) / Current.scenario.area.co2_emission_1990_billions.to_f
      when :net_energy_import, :renewable_percentage
        future
        # TODO implement
      when :total_energy_cost
        (future / BILLIONS)
      when :not_shown
        future
      when :targets_met
        future
    end
  end
  
  # The scale of the formatted output value.
  def formatted_output_scale
    return nil if unformatted_output.nil?
    start_scale = 0
    unit = :nounit
    if self.key == :total_energy_cost
      start_scale = 3 
      unit = :currency
    end
    Metric.scaling_in_words(Metric.scaled_value(unformatted_output, :start_scale => start_scale, :max_scale => 3)[0], :unit => unit)
  end

  # Methods that are included in the JSON dump.
  def to_json(options={})
    super(:only => [:id], :methods => [:output, :formatted_output_scale, :unformatted_output])
  end

  def data
    @data ||= Current.gql.query(query)
  end

  def result
    unless @result
      p = (data.present_value == 0.0) ? 0.0 : ((data.future_value / data.present_value - 1.0) * 100.0)
      p = 0.0 if p.nan?
      @result = p.round(2)
    end
    @result
  end
  
  
  
end

