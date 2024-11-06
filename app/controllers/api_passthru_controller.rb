class APIPassthruController < ApplicationController
  before_action :set_cors_headers

  # Receives a GET request intended for ETEngine and redirects the browser to the address
  # with their access token in the query string.
  def passthru
    response.set_header('Cache-Control', 'no-cache, no-store, max-age=0, must-revalidate')
    url = URI.parse(Settings.ete_url)
    url.path = "/api/v3/scenarios/#{params[:id]}/#{params[:rest]}"
    url.query = { access_token: identity_access_token.token }.to_query if signed_in?

    redirect_to url.to_s, allow_other_host: true
  end

  private

  # Allows the browser to make requests to this endpoint only from within ETModel.
  def set_cors_headers
    url = URI(request.url)

    response.set_header('Access-Control-Allow-Origin', "#{url.scheme}://#{url.host}")
    response.set_header('Access-Control-Allow-Methods', 'GET')
    response.set_header('Access-Control-Allow-Headers', 'Accept, Content-Type')
    response.set_header('Vary', 'Origin')

    render plain: '', content_type: 'text/plain' if request.method == 'OPTIONS'
  end
end
