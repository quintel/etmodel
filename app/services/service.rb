# frozen_string_literal: true

# Helpers for use in Services.
module Service
  def self.included(klass)
    klass.instance_eval do
      def self.call(...)
        new(...).call
      end
    end
  end
end
