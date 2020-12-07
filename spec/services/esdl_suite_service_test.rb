# frozen_string_literal: true

# WIP with all the stubs...

require 'rails_helper'

describe EsdlSuiteService, type: :service do
  let(:provider_url) { 'https://esdl.suite.test/auth' }
  let(:jwks_url) { provider_url + '/certs' }
  let(:redirect_url) { 'http://localhost/redirect'}
  let(:client_id) { 'etm' }
  let(:service) { described_class.new(provider_url, client_id, 'secret', redirect_url) }
  let(:jwk) {
    {:kid=>"VVFO0uuhCyz71dm56XUGZldW4YqPbNdUvfnt-FpUF0I", :kty=>"RSA", :alg=>"RS256", :use=>"sig", :n=>"lPYHgu7ovAOEzL3uBoN7KJWSn9UvqNqYbEkfMTbJrJRs8E1WULtxGzCDRVLJWBdLdq05_-8BXEISiggrWOukjsd-uqLTqQMI0he2bZMBRHSD2ISIXhGp5kpUCsbb0xd2bvp_LqSAuWKZmVLRWGRba6Hi-wFjLYc48tdTJUbbShZTojIsDY_ivH-5xJ6N_z7Iwq0HqPVGMiOywPGi9xqT9g5lUxhBuXJ7crmGncpxA4LH1foSBtIXqVTjESPc-G_4Si61xtmHckf3KkaFYgM89TxDtCyiwoKSu5RVbS38-jXP6Wx25F655244V-FSNty11ApSf2VaY9t5tCfv3RQvAw", :e=>"AQAB", :x5c=>["MIICqzCCAZMCBgFr+08ciDANBgkqhkiG9w0BAQsFADAZMRcwFQYDVQQDDA5lc2RsLW1hcGVkaXRvcjAeFw0xOTA3MTYxNTAxMzRaFw0yOTA3MTYxNTAzMTRaMBkxFzAVBgNVBAMMDmVzZGwtbWFwZWRpdG9yMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlPYHgu7ovAOEzL3uBoN7KJWSn9UvqNqYbEkfMTbJrJRs8E1WULtxGzCDRVLJWBdLdq05/+8BXEISiggrWOukjsd+uqLTqQMI0he2bZMBRHSD2ISIXhGp5kpUCsbb0xd2bvp/LqSAuWKZmVLRWGRba6Hi+wFjLYc48tdTJUbbShZTojIsDY/ivH+5xJ6N/z7Iwq0HqPVGMiOywPGi9xqT9g5lUxhBuXJ7crmGncpxA4LH1foSBtIXqVTjESPc+G/4Si61xtmHckf3KkaFYgM89TxDtCyiwoKSu5RVbS38+jXP6Wx25F655244V+FSNty11ApSf2VaY9t5tCfv3RQvAwIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQBMVrcaePdnAgaa+3grzzVQZi764jvRnJOWD0DoWzFpze52WeqVGXOCJ9tlOvO0wdwbSduiXRGLIe4PcxRUgZjhpbxy2mwHer3ycBdFTBaSwKGISyzT36XqeYZeXU0/pYDZZRBomN9d6Mn6Zi9itnhb47VlRrt4gm0LFTMEnRWsB9bP1uReTo9aHcl4E+PE9It+rdoyEWzhedzp+XKe3EEe9z3R9r1hSMUw3d1BqKHfNvO0CcreMN6GzVaf0qg/vlWYsDBMtykml8TNqRadx+cC2zgmtgwgtg8gPPRVMmytUUczHO/5dz74keBoBEh4iEqoSjfFM0zWNDe83rwS53j5"], :x5t=>"EVTMZLS5MuPyDywUTmLLq6W5SLg", :"x5t#S256"=>"9YuBH-hK7Zxy9M8g4LXx3pgp8_K177Tx3yk9LsDOgno"}
  }

  def stub_jwks_key
    allow(HTTParty)
      .to receive(:get)
      .with(jwks_url)
      .and_return(ServicesHelper::StubResponse.new(200, { :keys=>[jwk] }))
  end

  def stub_discovery
    allow(OpenIDConnect::Discovery::Provider::Config)
      .to receive(:discover!)
      .with(provider_url)
      .and_return(discovery_double)
  end

  def stub_access_token
    allow (OpenIDConnect::Client)
      .to recieve(:access_token!)
      .and_return()

  end

  def discovery_double
    discovery = double('discovery')
    {
      authorization_endpoint: '/auth',
      token_endpoint: '/token',
      userinfo_endpoint: '/userinfo',
      jwks_uri: jwks_url,
      issuer: provider_url
    }.each do |key, value|
      allow(discovery).to receive(key) { value }
    end

    discovery
  end

  describe '#redirect' do
    subject { service.redirect(code, nonce) }

    before do
      stub_discovery
      stub_jwks_key
    end

    context 'with valid code and valid nonce' do
      let(:nonce) { 'valid' }
      let(:code) { 'nja' }

      it { is_expected.to eq 1 }

    end
    context 'with valid code and invalid nonce' do

    end

    context 'with invalid code and valid nonce' do

    end

    context 'with invalid ocde and invalid nonce' do

    end
  end
end
