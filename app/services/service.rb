# frozen_string_literal: true

# Helpers for use in Services.
module Service
  def self.included(klass)
    klass.instance_eval do
      def self.call(*args)
        new(*args).call
      end
    end
  end
end
