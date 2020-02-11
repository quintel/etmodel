# frozen_string_literal: true

module YModel
  # Handles events that decorate the instances with methods.
  module Trigger
    protected

    def define_readers(model)
      model.instance_eval { attr_reader(*schema.attributes) }
    end

    private

    def inherited(model)
      define_readers(model)
      @triggered = true
    end
  end
end
