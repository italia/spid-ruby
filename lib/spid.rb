# frozen_string_literal: true

require "spid/authn_request"
require "spid/sso_request"
require "spid/sso_response"
require "spid/identity_providers"
require "spid/metadata"
require "spid/idp_metadata"
require "spid/version"
require "spid/identity_provider_configuration"
require "spid/service_provider_configuration"
require "spid/sso_settings"

module Spid # :nodoc:
  class UnknownAuthnComparisonMethodError < StandardError; end
  class UnknownAuthnContextError < StandardError; end
  class UnknownDigestMethodError < StandardError; end
  class UnknownSignatureMethodError < StandardError; end

  EXACT_COMPARISON = :exact
  MININUM_COMPARISON = :minumum
  BETTER_COMPARISON = :better
  MAXIMUM_COMPARISON = :maximum

  COMPARISON_METHODS = [
    EXACT_COMPARISON,
    MININUM_COMPARISON,
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

  L1 = "https://www.spid.gov.it/SpidL1"
  L2 = "https://www.spid.gov.it/SpidL2"
  L3 = "https://www.spid.gov.it/SpidL3"

  AUTHN_CONTEXTS = [
    L1,
    L2,
    L3
  ].freeze
end
