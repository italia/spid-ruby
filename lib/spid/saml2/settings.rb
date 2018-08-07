# frozen_string_literal: true

module Spid
  module Saml2
    class Settings # :nodoc:
      attr_reader :identity_provider
      attr_reader :service_provider

      def initialize(identity_provider:, service_provider:)
        @identity_provider = identity_provider
        @service_provider = service_provider
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
