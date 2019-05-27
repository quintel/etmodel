# frozen_string_literal: true

module ServicesHelper
  # Quacks a bit like an HTTParty::Response.
  StubResponse = Struct.new(:ok?, :body) do
    alias_method :to_h, :body

    def [](key)
      body[key]
    end
  end
end
