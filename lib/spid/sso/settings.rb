# frozen_string_literal: true

module Spid
  module Sso
    class Settings < ::OneLogin::RubySaml::Settings # :nodoc:
      attr_reader :service_provider_configuration,
                  :identity_provider_configuration,
                  :authn_context,
                  :authn_context_comparison

      # rubocop:disable Metrics/MethodLength
      def initialize(
            service_provider_configuration:,
            identity_provider_configuration:,
            authn_context: Spid::L1,
            authn_context_comparison: Spid::EXACT_COMPARISON
          )

        unless AUTHN_CONTEXTS.include?(authn_context)
          raise Spid::UnknownAuthnContextError,
                "Provided authn_context is not valid:" \
                " use one of #{AUTHN_CONTEXTS.join(', ')}"
        end

        unless COMPARISON_METHODS.include?(authn_context_comparison)
          raise Spid::UnknownAuthnComparisonMethodError,
                "Provided authn_context_comparison_method is not valid:" \
                " use one of #{COMPARISON_METHODS.join(', ')}"
        end

        @service_provider_configuration = service_provider_configuration
        @identity_provider_configuration = identity_provider_configuration
        @authn_context = authn_context
        @authn_context_comparison = authn_context_comparison

        super(sso_settings)
      end
      # rubocop:enable Metrics/MethodLength

      def sso_settings
        @sso_settings ||=
          begin
            [
              service_provider_configuration.sso_attributes,
              identity_provider_configuration.sso_attributes,
              sso_attributes
            ].inject(:merge)
          end
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def sso_attributes
        @sso_attributes ||=
          begin
            {
              protocol_binding: protocol_binding_value,
              name_identifier_format: name_identifier_format_value,
              authn_context: authn_context,
              authn_context_comparison: authn_context_comparison,
            }
          end
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      private

      def protocol_binding_value
        "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
      end

      def name_identifier_format_value
        "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
      end
    end
  end
end
