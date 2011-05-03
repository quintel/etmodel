module ApplicationController::ExceptionHandling
  extend ActiveSupport::Concern

  included do
    HTTPStatus::Base.template_layout = 'pages'

    self.rescue_from(ActionController::NotImplemented) do |exception|
      logger.debug "Handling ActionController::NotImplemented."
      notify_hoptoad(exception)
      http_status_exception(HTTPStatus::MethodNotAllowed.new(exception.message))
    end

    rescue_from(ActionController::MethodNotAllowed) do |exception|
      logger.debug "Handling ActionController::MethodNotAllowed."
      notify_hoptoad(exception)
      http_status_exception(HTTPStatus::MethodNotAllowed.new(exception.message))
    end

    rescue_from(ActiveRecord::RecordNotFound) do |exception|
      logger.debug "Handling ActiveRecord::RecordNotFound." + exception.inspect
      notify_hoptoad(exception)
      http_status_exception(HTTPStatus::NotFound.new(exception.message))
    end

    rescue_from(ActionController::RoutingError) do |exception|
      logger.debug "Handling ActiveRecord::RoutingError."
      notify_hoptoad(exception)
      http_status_exception(HTTPStatus::MovedPermanently.new(exception.message))
    end

    rescue_from(AbstractController::ActionNotFound) do |exception|
      logger.debug "Handling AbstractController::ActionNotFound."
      notify_hoptoad(exception)
      http_status_exception(HTTPStatus::MovedPermanently.new(exception.message))
    end


    rescue_from(HTTPStatus::Base) do |exception|
      logger.debug "Handling HTTPStatus::Base."
      # If there is no custom message translate the status code
      if exception.message == "HTTPStatus::%s" % exception.status.to_s.camelcase
        exception = eval("#{exception.class}.new('%s')" % [t('http_status.%s' % exception.status.to_s)])
      end

      http_status_exception(exception)
    end
    

    if !(Rails.env.development? || Rails.env.test?)
      rescue_from(RuntimeError) do |exception|
        notify_hoptoad(exception)
        logger.fatal exception.message
        http_status_exception(HTTPStatus::InternalServerError.new("We're sorry an error has occured"))
      end
    end
  end
end
