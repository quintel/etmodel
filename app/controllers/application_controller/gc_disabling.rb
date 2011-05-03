# Adds a method to do disable the Garbage Collector.
module ApplicationController::GcDisabling

  extend ActiveSupport::Concern

 
  # Disable and enable the garbage collector. Use this in a around_filter 
  # in a controller.
  # @param [Proc] Proc the values
  def disable_gc(&block)
    return yield if !GC_DISABLING_HACK_ENABLED
    logger.info "Disabling GC."
    GC.disable
    yield
    GC.start      
    ensure
      logger.info "Enabling GC."
      GC.enable
  end


end
#end