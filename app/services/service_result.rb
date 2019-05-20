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
end
