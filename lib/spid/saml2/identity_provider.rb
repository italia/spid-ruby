# frozen_string_literal: true

module Spid
  module Saml2
    class IdentityProvider # :nodoc:
      attr_reader :name
      attr_reader :entity_id
      attr_reader :sso_target_url
      attr_reader :slo_target_url
      attr_reader :cert_fingerprint
      attr_reader :cert

      # rubocop:disable Metrics/ParameterLists
      def initialize(
            name:,
            entity_id:,
            sso_target_url:,
            slo_target_url:,
            cert_fingerprint:,
            cert:
          )
        @name = name
        @entity_id = entity_id
        @sso_target_url = sso_target_url
        @slo_target_url = slo_target_url
        @cert_fingerprint = cert_fingerprint
        @cert = cert
      end
      # rubocop:enable Metrics/ParameterLists
    end
  end
end
