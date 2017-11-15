class AddInternationalTransportData < ActiveRecord::Migration[5.0]
	TRANSFORMERS = {
    "input_element_id" =>       -> (id, map) { InputElement.find_by_key!(map['input_element_id'][id.to_s]) },
    "slide_id" =>               -> (id, map) { Slide.find_by_key!(map['slide_id'][id.to_s]) },
    "sidebar_item_id" =>        -> (id, map) { SidebarItem.find_by_key!(map['sidebar_item_id'][id.to_s]) },
    "output_element_id" =>      -> (id, map) { OutputElement.find_by_key!(map['output_element_id'][id.to_s]) },
    "alt_output_element_id" =>  -> (id, map) { OutputElement.find_by_key!(map['output_element_id'][id.to_s]) },
    "output_element_type_id" => -> (id, map) { OutputElementType.find_by_name!(map['output_element_type_id'][id.to_s]) },
    "parent_id" =>              -> (id, map) { SidebarItem.find_by_key!(map['sidebar_item_id'][id.to_s]) },
    "tab_id" =>                 -> (id, map) { Tab.find_by_key!(map['tab_id'][id.to_s]) }
	}

  def up
    dir = File.expand_path(File.dirname(__FILE__) + "/20171115131941_add_international_transport_data")
    map = JSON.parse(File.read("#{dir}/id_map.json"))

    # [filename without ext, class, extra pre-transformer callables]
    additions = [
      ['output_elements', OutputElement, []],
      ['output_element_series', OutputElementSerie, []],
      ['sidebar_items', SidebarItem, []],
      ['slides', Slide, []],
      ['input_elements', InputElement, []],
      ['descriptions', Description, [method(:translate_describable_attrs)]]
    ]

    ActiveRecord::Base.transaction do
      additions.each do |(file, klass, extras)|
        puts "Adding #{file.gsub(/_/, ' ')}"

        JSON.parse(File.read("#{dir}/#{file}.json")).each do |record|
          attrs = extras.reduce(record) { |d, trans| trans.call(d, map) }
          klass.create!(translate_attrs(attrs, map))
        end
      end
    end
  end

  private

  # Generic processor; maps IDs from a local data dump to real IDs via the
  # object. key.
  def translate_attrs(attributes, map)
    translated = {}

    attributes.each do |key, value|
      next unless value.present?

      if TRANSFORMERS.key?(key)
        value = TRANSFORMERS[key].call(value, map)
        key = key.gsub(/_id$/, '')
      elsif key =~ /_id$/
        raise "Untransformed value #{key}: #{value} in #{attributes.inspect}"
      end

      translated[key] = value
    end

    translated
  end

  # Pre-processes attributes for Description records.
  def translate_describable_attrs(attributes, map)
    describable_id   = attributes.delete('describable_id')
    describable_type = attributes.delete('describable_type')

    attributes['describable'] =
      TRANSFORMERS["#{describable_type.underscore}_id"].call(describable_id, map)

    attributes
  end
end
