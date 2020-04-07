# frozen_string_literal: true

module ServicesHelper
  # Quacks a bit like an HTTParty::Response.
  StubResponse = Struct.new(:code, :body) do
    alias_method :to_h, :body

    def initialize(code, *rest)
      case code
      when true then super(200, *rest)
      when false then super(500, *rest)
      else super
      end
    end

    def ok?
      (200..299).cover?(code)
    end

    def [](key)
      body[key]
    end

    def request
      Struct.new(:raw_body).new('{}')
    end
  end
end
