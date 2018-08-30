# frozen_string_literal: true

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
        Spid::Saml2::LogoutResponseValidator.new(
          response: saml_response,
          settings: settings
        ).call
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
        saml_response.issuer
      end

      def settings
        @settings ||= Spid::Saml2::Settings.new(
          service_provider: service_provider,
          identity_provider: identity_provider
        )
      end

      def saml_response
        @saml_response ||= Spid::Saml2::LogoutResponse.new(
          body: body
        )
      end
    end
  end
end
