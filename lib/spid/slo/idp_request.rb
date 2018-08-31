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

      def response
        [
          idp_logout_response.to_saml
        ]
      end

      def valid?
        validator.call
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
        idp_logout_request.issuer
      end

      def settings
        @settings ||= Spid::Saml2::Settings.new(
          service_provider: service_provider,
          identity_provider: identity_provider
        )
      end

      def validator
        @validator ||=
          begin
            Spid::Saml2::IdpLogoutRequestValidator.new(
              request: idp_logout_request
            )
          end
      end

      def idp_logout_request
        @idp_logout_request ||=
          begin
            Spid::Saml2::IdpLogoutRequest.new(
              saml_message: saml_message
            )
          end
      end

      def idp_logout_response
        @idp_logout_response ||=
          begin
            Spid::Saml2::IdpLogoutResponse.new(
              settings: settings,
              request_uuid: idp_logout_request.id
            )
          end
      end
    end
  end
end
