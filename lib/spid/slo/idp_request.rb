# frozen_string_literal: true

module Spid
  module Slo
    class IdpRequest # :nodoc:
      include Spid::Saml2::Utils

      attr_reader :body
      attr_reader :saml_message
      attr_reader :session_index

      def initialize(body:, session_index:)
        @body = body
        @saml_message = decode_and_inflate(body)
        @session_index = session_index
      end

      def identity_provider
        @identity_provider ||=
          IdentityProviderManager.find_by_entity(issuer)
      end

      def service_provider
        @service_provider ||=
          Spid.configuration.service_provider
      end
    end
  end
end
