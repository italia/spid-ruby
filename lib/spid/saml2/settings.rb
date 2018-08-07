# frozen_string_literal: true

module Spid
  module Saml2
    class Settings # :nodoc:
      attr_reader :identity_provider
      attr_reader :service_provider
      attr_reader :authn_context

      def initialize(identity_provider:, service_provider:, authn_context: nil)
        @identity_provider = identity_provider
        @service_provider = service_provider
        @authn_context = authn_context || Spid::L1
      end

      def idp_entity_id
        identity_provider.entity_id
      end

      def sp_entity_id
        service_provider.host
      end

      def acs_index
        "0"
      end
    end
  end
end
