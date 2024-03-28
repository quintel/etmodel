# frozen_string_literal: true

# Represents the result of executing a service.
class ServiceResult
  attr_reader :value, :errors

  # Public: Creates a successful result.
  #
  # value - An optional result to be returned to the caller.
  #
  # Returns a ServiceResult.
  def self.success(value = nil)
    new(true, value: value)
  end

  # Public: Creates a failure result.
  #
  # errors - An array of errors which occurred.
  # value  - An optional value to be returned to the caller. This may be useful
  #          when an ActiveRecord failed validation and you wish to use the
  #          object in a form.
  #
  # Returns a ServiceResult.
  def self.failure(errors = [], value = nil)
    new(false, value: value, errors: Array(errors))
  end

  # Public: Creates a failure result from a Faraday::UnprocessableEntityError.
  def self.failure_from_unprocessable_entity(exception, value = nil)
    errors = exception.response[:body]['errors']

    if errors.is_a?(Hash)
      errors = exception.response[:body]['errors'].flat_map do |key, messages|
        messages.map { |message| "#{key.humanize} #{message}" }
      end
    end

    failure(errors, value)
  end

  def self.single_failure_from_unprocessable_entity_on_multiple_objects(exception, value = nil)
    errors = exception.response[:body]['errors']
    errors = errors.values.first if errors.is_a?(Hash)

    failure(errors, value)
  end

  def initialize(success, value: nil, errors: [])
    @success = success
    @value = value
    @errors = errors
  end

  private_class_method :new

  def successful?
    @success
  end

  def failure?
    !successful?
  end

  def or(fallback = nil)
    if successful?
      value
    elsif fallback.nil? && block_given?
      yield
    else
      fallback
    end
  end

  # Public: Returns the value if the result is successful, otherwise raises an error with the
  # given message.
  def unwrap(error_msg = nil)
    error_msg ||= 'Cannot unwrap failed ServiceResult'
    failure? ? raise("#{error_msg}: #{Array(@errors).join(', ')}") : @value
  end
end
