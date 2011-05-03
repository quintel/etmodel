
class Blueprint < ActiveRecord::Base

  belongs_to :blueprint_model

  has_many :datasets
  # I explicitly call the association *_records, because we currently also 
  # have a method #converters that returns qernel_converters. After renaming
  # #converters into #qernel_converters we can rename it back
  has_and_belongs_to_many :converter_records, :class_name => "Converter"
  has_many :links, :dependent => :delete_all
  has_many :slots, :dependent => :delete_all

  scope :ordered, order('id DESC')

  scope :latest, order('id DESC').limit(1)

  scope :has_group, lambda {|group| joins(:groups).where(["groups.id = ?", group.id]) }

  def copy_blueprint!
    blueprint = self.clone
    blueprint.created_at = nil
    blueprint.updated_at = nil
    Blueprint.transaction do 
      blueprint.save!
      links.each do |link|
        blueprint.links << link.clone
      end
      slots.each do |slot|
        blueprint.slots << slot.clone
      end
      converter_records.each do |converter|
        blueprint.converter_records << converter
      end
    end
    blueprint
  end

  def to_label
    "##{id} #{description}"
  end

  ##
  #
  #
  # @return [Qernel::Graph] a memcached clone of the qernel graph
  #
  def to_qernel
    marshal = Rails.cache.fetch("/blueprint/#{id}") do
      Marshal.dump(build_qernel)
    end
    Marshal.load marshal
  end

  private

  def build_qernel
    qernel_graph = Qernel::Graph.new(converters)
    qernel_graph.graph_id = id
    # Here we explicitly set the reference to dataset (via graph) for all the qernel objects
    (converters + carriers + qernel_slots + qernel_links).each do |obj|
      obj.graph = qernel_graph
    end
    qernel_graph
  end

  ##
  # ATTENTION: DO NOT MISTAKE converters with converter_records
  # converter_records refers to the actual ActiveRecord Converter Records 
  # see has_many :converter_records. Where as #converters are {Qernel::Converter}
  #
  #
  def converters
    converters_hash.values
  end

  def converters_hash
    @converters_hash ||= converter_records.includes(:groups).inject({}) do |hsh, c|
      hsh.merge c.converter_id => c.to_qernel
    end
  end

  def carriers
    carriers_hash.values
  end

  def carriers_hash
    @carriers_hash ||= Carrier.all.inject({}) do |hsh, c|
      hsh.merge c.id => c.to_qernel
    end
  end

  def qernel_links
    @qernel_links ||= links.map do |link|
      parent_qernel = converters_hash[link.parent_id]
      child_qernel = converters_hash[link.child_id]
      carrier_qernel = carriers_hash[link.carrier_id]
      Qernel::Link.new(link.id,
        parent_qernel,
        child_qernel,
        carrier_qernel,
        Link::LINK_TYPES[link.link_type])
    end
  end

  def qernel_slots
    unless @slot_qernels
      @slot_qernels ||= slots.map do |slot|
        converter = converters_hash[slot.converter_id]
        carrier = carriers_hash[slot.carrier_id]
        q_slot = Qernel::Slot.new(slot.id, converter, carrier, slot.direction == 0 ? :input : :output)
        converter.add_slot(q_slot)
        q_slot
      end
    end
    @slot_qernels
  end



end


# == Schema Information
#
# Table name: blueprints
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  graph_version :string(255)
#  description   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

