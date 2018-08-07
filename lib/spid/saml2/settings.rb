# frozen_string_literal: true

module Spid
  module Saml2
    class Settings # :nodoc:
      attr_reader :identity_provider

      def initialize(identity_provider:)
        @identity_provider = identity_provider
      end

      def idp_entity_id
        identity_provider.entity_id
      end

      def acs_index
        "0"
      end
    end
  end
end
