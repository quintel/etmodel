# frozen_string_literal: true

# Part of the Rails 7.0 upgrade process. Cookie digests now use SHA256 instead of SHA1. This
# upgrades cookies to use SHA256.
#
# See https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#key-generator-digest-class-changing-to-use-sha256
Rails.application.config.action_dispatch.cookies_rotations.tap do |cookies|
  salt = Rails.application.config.action_dispatch.authenticated_encrypted_cookie_salt
  secret_key_base = Rails.application.credentials.secret_key_base || ENV["SECRET_KEY_BASE"]

  key_generator = ActiveSupport::KeyGenerator.new(
    secret_key_base, iterations: 1000, hash_digest_class: OpenSSL::Digest::SHA1
  )
  key_len = ActiveSupport::MessageEncryptor.key_len
  secret = key_generator.generate_key(salt, key_len)

  cookies.rotate(:encrypted, secret)
end
