# frozen_string_literal: true

require "spid/authn_request"
require "spid/version"

module Spid # :nodoc:
  class UnknownAuthnComparisonMethodError < StandardError; end
  class UnknownAuthnContextError < StandardError; end

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

  L1 = "urn:oasis:names:tc:SAML:2.0:ac:classes:SpidL1"
  L2 = "urn:oasis:names:tc:SAML:2.0:ac:classes:SpidL2"
  L3 = "urn:oasis:names:tc:SAML:2.0:ac:classes:SpidL3"

  AUTHN_CONTEXTS = [
    L1,
    L2,
    L3
  ].freeze
end
