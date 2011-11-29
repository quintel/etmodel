require 'net/http'
require 'uri'

# Simple proxy to prevent AJAX Cross Domain Policy restrictions.
# Usage: GET /proxy/api_scenarios/new.json
# 
# TODO: adapt js code and browser detection
# TODO: add other HTTP methods
# TODO: error handling
class ProxyController < ApplicationController
  def index
    base_host = APP_CONFIG[:api_url]
    url = params[:url]
    uri = URI.parse("#{base_host}/#{url}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    # request['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest'
    
    response = http.request(request)    
    render :text => response.body, :content_type => response['content-type']
  end
end