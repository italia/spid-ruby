# frozen_string_literal: true

require "onelogin/ruby-saml/logoutresponse"

module Spid
  module Slo
    class Response # :nodoc:
      attr_reader :body
      attr_reader :session_index

      def initialize(body:, session_index:)
        @body = body
        @session_index = session_index
      end

      def valid?
        saml_response.validate
      end

      def errors
        saml_response.errors
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
        saml_response.issuers.first
      end

      private

      def saml_settings
        slo_settings.saml_settings
      end

      def saml_response
        @saml_response ||= ::OneLogin::RubySaml::Logoutresponse.new(
          body,
          saml_settings
        )
      end
    end
  end
end
