# frozen_string_literal: true

module YModel
  # This mixin holds the query methods.
  module Queryable
    def find(index)
      all.find { |record| record.index == index }
    end

    def find!(index)
      find(index) || raise_record_not_found_exception!(index)
    end

    def find_by(attributes)
      sanitized = sanitize_attributes(attributes)
      all.each do |record|
        return record if sanitized.all? { |k, v| record.send(k) == v }
      end

      nil
    end

    def find_by!(attributes)
      find_by(attributes) || raise_record_not_found_exception!(attributes)
    end

    def find_by_key(key)
      all.find do |record|
        record.key == key.to_s
      end
    end

    def find_by_key!(key)
      find_by_key(key) || raise_record_not_found_exception!(key)
    end

    def all
      @all ||= load_records!
    rescue Errno::ENOENT
      raise YModel::SourceFileNotFound
    end

    def where(attributes)
      sanitized = sanitize_attributes(attributes)

      if sanitized.length != attributes.length
        unpermitted = (attributes.keys.map(&:to_sym) - sanitized.keys)
        message = "These attributes are not allowed: #{unpermitted}"

        raise UnpermittedParamsError, message
      end

      all.select do |record|
        sanitized.all? { |key, value| record.send(key) == value }
      end
    end

    # Beware of using this method. If all attributes get removed during
    # sanitation it returns the equivalent of #all.
    def where!(attributes)
      sanitized = sanitize_attributes(attributes)
      all.select do |record|
        sanitized.all? { |key, value| record.send(key) == value }
      end
    end

    def sanitize_attributes(attributes)
      attributes.symbolize_keys!
        .select { |attr| schema.include?(attr) }
    end

    def raise_record_not_found_exception!(attributes = nil)
      if attributes.is_a?(Hash)
        message = "Couldn't find #{name} with "
        attributes.each { |k, v| message += "#{k}: #{v}" }
      else
        message = "Couldn't find #{name} #{attributes}"
      end
      raise YModel::RecordNotFound, message
    end
  end
end
