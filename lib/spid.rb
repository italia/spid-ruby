# frozen_string_literal: true

require "spid/saml2"
require "spid/authn_request"
require "spid/logout_request"
require "spid/sso"
require "spid/slo"
require "spid/rack"
require "spid/metadata"
require "spid/version"
require "spid/configuration"
require "spid/identity_provider_manager"

module Spid # :nodoc:
  class UnknownAuthnComparisonMethodError < StandardError; end
  class UnknownAuthnContextError < StandardError; end
  class UnknownDigestMethodError < StandardError; end
  class UnknownSignatureMethodError < StandardError; end

  EXACT_COMPARISON = :exact
  MINIMUM_COMPARISON = :minimum
  BETTER_COMPARISON = :better
  MAXIMUM_COMPARISON = :maximum

  BINDINGS_HTTP_POST = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
  BINDINGS_HTTP_REDIRECT = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"

  COMPARISON_METHODS = [
    EXACT_COMPARISON,
    MINIMUM_COMPARISON,
    BETTER_COMPARISON,
    MAXIMUM_COMPARISON
  ].freeze

  SHA256 = XMLSecurity::Document::SHA256
  SHA384 = XMLSecurity::Document::SHA384
  SHA512 = XMLSecurity::Document::SHA512

  DIGEST_METHODS = [
    SHA256,
    SHA384,
    SHA512
  ].freeze

  RSA_SHA256 = XMLSecurity::Document::RSA_SHA256
  RSA_SHA384 = XMLSecurity::Document::RSA_SHA384
  RSA_SHA512 = XMLSecurity::Document::RSA_SHA512

  SIGNATURE_METHODS = [
    RSA_SHA256,
    RSA_SHA384,
    RSA_SHA512
  ].freeze

  SIGNATURE_ALGORITHMS = {
    RSA_SHA256 => OpenSSL::Digest::SHA256.new,
    RSA_SHA384 => OpenSSL::Digest::SHA384.new,
    RSA_SHA512 => OpenSSL::Digest::SHA512.new
  }.freeze

  L1 = "https://www.spid.gov.it/SpidL1"
  L2 = "https://www.spid.gov.it/SpidL2"
  L3 = "https://www.spid.gov.it/SpidL3"

  AUTHN_CONTEXTS = [
    L1,
    L2,
    L3
  ].freeze

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset_configuration!
    @configuration = Configuration.new
  end

  def self.configure
    yield configuration
  end
end
