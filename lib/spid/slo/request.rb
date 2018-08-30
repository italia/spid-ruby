# frozen_string_literal: true

module Spid
  module Slo
    class Request # :nodoc:
      attr_reader :idp_name
      attr_reader :session_index
      attr_reader :relay_state

      def initialize(idp_name:, session_index:, relay_state: nil)
        @idp_name = idp_name
        @session_index = session_index
        @relay_state =
          begin
            relay_state || Spid.configuration.default_relay_state_path
          end
      end

      def url
        [
          settings.idp_slo_target_url,
          query_params_signer.escaped_signed_query_string
        ].join("?")
      end

      def uuid
        logout_request.uuid
      end

      def query_params_signer
        @query_params_signer ||=
          begin
            Spid::Saml2::Utils::QueryParamsSigner.new(
              saml_message: saml_message,
              relay_state: relay_state,
              private_key: settings.private_key,
              signature_method: settings.signature_method
            )
          end
      end

      def saml_message
        @saml_message ||= logout_request.to_saml
      end

      def logout_request
        @logout_request ||= Spid::Saml2::LogoutRequest.new(
          settings: settings,
          session_index: session_index
        )
      end

      def settings
        @settings ||= Spid::Saml2::Settings.new(
          service_provider: service_provider,
          identity_provider: identity_provider
        )
      end

      def identity_provider
        @identity_provider ||=
          IdentityProviderManager.find_by_name(idp_name)
      end

      def service_provider
        @service_provider ||=
          Spid.configuration.service_provider
      end
    end
  end
end
