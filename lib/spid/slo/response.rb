# frozen_string_literal: true

module Spid
  module Slo
    class Response # :nodoc:
      attr_reader :body
      attr_reader :session_index
      attr_reader :request_uuid

      def initialize(body:, session_index:, request_uuid:)
        @body = body
        @session_index = session_index
        @request_uuid = request_uuid
      end

      def valid?
        validator.call
      end

      def response
        []
      end

      def errors
        validator.errors
      end

      def validator
        @validator ||=
          begin
            Spid::Saml2::LogoutResponseValidator.new(
              response: saml_response,
              settings: settings,
              request_uuid: request_uuid
            )
          end
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
