# frozen_string_literal: true

module YModel
  # Handles events that decorate the instances with methods.
  module Triggerable
    protected

    def define_readers(model)
      model.instance_eval do
        schema.attributes.each { |attribute| define_reader(attribute) }
      end
    end

    private

    def inherited(model)
      define_readers(model)
      @triggered = true
    end
  end
end
