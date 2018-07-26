# frozen_string_literal: true

require "onelogin/ruby-saml/logoutresponse"

module Spid
  module Slo
    class Response # :nodoc:
      attr_reader :body
      attr_reader :session_index
      attr_reader :matches_request_id

      def initialize(body:, session_index:, matches_request_id:)
        @body = body
        @session_index = session_index
        @matches_request_id = matches_request_id
      end

      def valid?
        validated_saml_response.validate
      end

      def errors
        validated_saml_response.errors
      end

      def saml_settings
        slo_settings.saml_settings
      end

      def slo_settings
        Settings.new(
          service_provider: service_provider,
          identity_provider: identity_provider,
          session_index: session_index
        )
      end

      def identity_provider
        @identity_provider ||=
          IdentityProviderManager.find_by_entity(issuer)
      end

      def service_provider
        @service_provider ||=
          Spid.configuration.service_provider
      end

      def issuer
        saml_response.issuer.strip
      end

      private

      def saml_response
        ::OneLogin::RubySaml::Logoutresponse.new(
          body,
          nil,
          matches_request_id: matches_request_id
        )
      end

      def validated_saml_response
        @validated_saml_response ||=
          begin
            response = saml_response
            response.settings = saml_settings
            response
          end
      end
    end
  end
end
