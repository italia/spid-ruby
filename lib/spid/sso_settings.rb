# frozen_string_literal: true

module Spid
  class SsoSettings < ::OneLogin::RubySaml::Settings # :nodoc:
    attr_reader :service_provider_configuration,
                :identity_provider_configuration,
                :authn_context,
                :authn_context_comparison

    def initialize(
          service_provider_configuration:,
          identity_provider_configuration:,
          authn_context: Spid::L1,
          authn_context_comparison: Spid::EXACT_COMPARISON
        )
      @service_provider_configuration = service_provider_configuration
      @identity_provider_configuration = identity_provider_configuration
      @authn_context = authn_context
      @authn_context_comparison = authn_context_comparison
      super(sso_attributes)
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def sso_attributes
      return @sso_attributes if @sso_attributes.present?
      @sso_attributes = {
        idp_sso_target_url: identity_provider_configuration.sso_target_url,
        assertion_consumer_service_url: service_provider_configuration.sso_url,
        protocol_binding: protocol_binding_value,
        issuer: service_provider_configuration.host,
        private_key: service_provider_configuration.private_key,
        certificate: service_provider_configuration.certificate,
        name_identifier_format: name_identifier_format_value,
        authn_context: authn_context,
        authn_context_comparison: authn_context_comparison,
        idp_cert_fingerprint: identity_provider_configuration.cert_fingerprint,
        security: {
          authn_requests_signed: true,
          embed_sign: true,
          digest_method: service_provider_configuration.digest_method,
          signature_method: service_provider_configuration.signature_method
        }
      }
      @sso_attributes[:force_authn] = true if authn_context > Spid::L1
      @sso_attributes
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
