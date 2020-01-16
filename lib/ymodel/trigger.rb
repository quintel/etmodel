module YModel
  module Trigger

    protected

    def set_readers(model)
      model.instance_eval { attr_reader *schema.attributes }
    end

    private

    def inherited model
      set_readers(model)
      @triggered = true
    end
  end
end
