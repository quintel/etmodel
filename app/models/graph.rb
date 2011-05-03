##
#
# Graph replaces ::Graph in the blueprint way of doing things. A Graph is the thing that a user
# will choose and use. It references a blueprint, which defines the structure of the graph, and a graph,
# which defines the data.
#
# The graph_id formerly used to reference ::Graph now references both a Graph *and* a Dataset. That
# is, the graph.id == graph.dataset.id
#
# The user would select a Graph, which can be looked up by id, i.e.
# Graph.find(graph_id)
#
#
class Graph < ActiveRecord::Base
  belongs_to :blueprint # blueprint for the graph
  belongs_to :dataset # data for the graph

  scope :ordered, order('created_at DESC')

  delegate :description, :to => :blueprint

  def country
    dataset.region_code
  end

  def version
    blueprint.graph_version
  end


  @@future_qernels = {}
  @@present_qernels = {}


  # to be returned by Current.graph, Graph needs to provide the methods
  # latest_from_country, gql, create_gql

  def self.latest_from_country(country)
    self.find_by_dataset_id(Dataset.latest_from_country(country).id)
    #Graph.ordered.country(country).first
  end

  def gql
  end

  # to support Gql, Graph needs to provide the methods calculated_present_qernel_qernel and future
  def create_gql
  end

  def present
  end

  def future
  end

  def present_qernel
  end

  ##
  #
  #
  def calculated_present_qernel
  end

  def calculated_present_data
  end

  def self.present_qernel_for(graph)
  end

  def self.future_qernel_for(graph)
  end

  ##
  # Build a Qernel::Graph
  #
  # @return [Qernel::Graph]
  def to_qernel
  end

  def build_qernel
  end

end

# == Schema Information
#
# Table name: graphs
#
#  id           :integer(4)      not null, primary key
#  blueprint_id :integer(4)
#  dataset_id   :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

