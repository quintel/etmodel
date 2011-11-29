require 'net/http'
require 'uri'

# Simple proxy to prevent AJAX Cross Domain Policy restrictions.
# Usage: GET /proxy/api_scenarios/new.json
#
# TODO: adapt js code and browser detection
# TODO: error handling
class ProxyController < ApplicationController
  def index
    base_host = APP_CONFIG[:api_url]
    url = params[:url]
    uri = URI.parse("#{base_host}/#{url}")
    http = Net::HTTP.new(uri.host, uri.port)

    method = request.method.downcase.to_sym

    case method
    when :get
      req = Net::HTTP::Get.new(uri.request_uri)
    when :post
      req = Net::HTTP::Post.new(uri.request_uri)
      req.set_form_data(request.request_parameters)
    when :put
      req = Net::HTTP::Put.new(uri.request_uri)
      req.set_form_data(request.request_parameters)
    when :delete
      req = Net::HTTP::Delete.new(uri.request_uri)
    else
      raise 'Invalid HTTP Method'
    end

    # req['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest'

    response = http.request(req)
    render :text => response.body, :content_type => response['content-type']
  end
end
