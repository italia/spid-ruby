# frozen_string_literal: true

module Spid
  module Sso
    class Settings # :nodoc:
      attr_reader :service_provider,
                  :identity_provider,
                  :authn_context
      def initialize(
            service_provider:,
            identity_provider:,
            authn_context: Spid::L1
          )

        unless AUTHN_CONTEXTS.include?(authn_context)
          raise Spid::UnknownAuthnContextError,
                "Provided authn_context is not valid:" \
                " use one of #{AUTHN_CONTEXTS.join(', ')}"
        end

        @service_provider = service_provider
        @identity_provider = identity_provider
        @authn_context = authn_context
      end
      # rubocop:enable Metrics/MethodLength

      def saml_settings
        ::OneLogin::RubySaml::Settings.new(sso_attributes)
      end

      def sso_attributes
        [
          service_provider.sso_attributes,
          identity_provider.sso_attributes,
          inner_sso_attributes,
          force_authn_attributes
        ].inject(:merge)
      end

      def inner_sso_attributes
        {
          protocol_binding: protocol_binding_value,
          name_identifier_format: name_identifier_format_value,
          authn_context: authn_context,
          authn_context_comparison: Spid::MINIMUM_COMPARISON
        }
      end

      def force_authn_attributes
        return {} if authn_context <= Spid::L1
        {
          force_authn: true
        }
      end

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
