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
#  gquery_key     :string(255)
#

class Constraint < ActiveRecord::Base
  has_and_belongs_to_many :root_nodes
  belongs_to :gquery

  def to_json(options={})
    super(:only => [:id], :methods => [:output, :formatted_output_scale, :unformatted_output])
  end

  def data
    @data ||= Current.gql.query(query)
  end
  
end

