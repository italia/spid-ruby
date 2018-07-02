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

  L1 = "https://www.spid.gov.it/SpidL1"
  L2 = "https://www.spid.gov.it/SpidL2"
  L3 = "https://www.spid.gov.it/SpidL3"

  AUTHN_CONTEXTS = [
    L1,
    L2,
    L3
  ].freeze
end
