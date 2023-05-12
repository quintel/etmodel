# frozen_string_literal: true

module Engine
  # Represents a scenario on ETEngine.
  class Scenario < Dry::Struct
    transform_keys(&:to_sym)

    CoercibleTime = Dry::Types['optional.time'].constructor { |input| Time.parse(input).utc }

    attribute  :area_code,       Dry::Types['strict.string']
    attribute  :balanced_values, Dry::Types['strict.hash']
    attribute  :coupling,        Dry::Types['strict.bool']
    attribute  :end_year,        Dry::Types['strict.integer']
    attribute  :id,              Dry::Types['strict.integer']
    attribute  :keep_compatible, Dry::Types['strict.bool']
    attribute  :metadata,        Dry::Types['strict.hash']
    attribute  :private,         Dry::Types['strict.bool']
    attribute  :user_values,     Dry::Types['strict.hash']

    attribute? :esdl_exportable, Dry::Types['strict.bool']
    attribute? :owner,           User | Dry::Types['strict.nil']
    attribute? :scaling,         ScenarioScaler | Dry::Types['strict.nil']
    attribute? :template,        Dry::Types['optional.integer']
    attribute? :url,             Dry::Types['optional.string']

    attribute? :created_at,      CoercibleTime
    attribute? :updated_at,      CoercibleTime

    alias_method :keep_compatible?, :keep_compatible
    alias_method :private?, :private
    alias_method :edsl_exportable?, :esdl_exportable
    alias_method :coupled?, :coupling

    # Loads multiple scenarios by ID. Excludes any missing or inaccessable scenarios.
    #
    # This exists for backwards compatibility with the old ActiveResource class and would ideally
    # be moved to a Service object.
    def self.batch_load(http_client, ids)
      return [] if ids.empty?

      url = "/api/v3/scenarios/#{ids.uniq.join(',')}/batch"
      response = http_client.get(url)

      response.body.map { |scn| new(scn) }
    rescue Faraday::Error
      Sentry.capture_message('Scenario batch load failed', level: :error, extra: { url: })
      []
    end

    def to_param
      id.to_s
    end

    def title
      metadata['title'].presence
    end

    def description
      metadata['description'].presence
    end

    def loadable?
      Engine::Area.code_exists?(area_code)
    end

    def owned?
      owner.present?
    end

    def inputs(http_client)
      http_client.get("/api/v3/scenarios/#{id}/inputs").body
    end

    def to_request_attributes
      to_h.except(:balanced_values, :owner, :scaler, :created_at, :updated_at)
    end
  end
end
