# frozen_string_literal: true

unless Gem.loaded_specs['vcr'].version == Gem::Version.create('6.0.0')
  raise 'VCR has been updated. This patch may not be needed.'
end

require 'vcr/library_hooks/webmock'

# https://github.com/vcr/vcr/pull/907/files
module VCR
  class LibraryHooks
    module WebMock
      def global_hook_disabled?(request)
        requests = Thread.current[:_vcr_webmock_disabled_requests]
        requests&.include?(request)
      end

      def global_hook_disabled_requests
        Thread.current[:_vcr_webmock_disabled_requests] ||= []
      end
    end
  end
end
