# frozen_string_literal: true

require "spid/authn_request"
require "onelogin/ruby-saml/settings"

module Spid
  class SsoRequest # :nodoc:
    attr_reader :service_provider_configuration,
                :identity_provider_configuration,
                :authn_context,
                :authn_context_comparison

    # rubocop:disable Metrics/MethodLength
    def initialize(
          identity_provider_configuration:,
          service_provider_configuration:,
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
    end
    # rubocop:enable Metrics/MethodLength

    def to_saml
      authn_request.create(saml_settings)
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def authn_request_attributes
      return @authn_request_attributes if @authn_request_attributes.present?
      @authn_request_attributes = {
        idp_sso_target_url: identity_provider_configuration.sso_target_url,
        assertion_consumer_service_url: service_provider_configuration.sso_url,
        protocol_binding: protocol_binding,
        issuer: service_provider_configuration.host,
        private_key: service_provider_configuration.private_key,
        certificate: service_provider_configuration.certificate,
        name_identifier_format: name_identifier_format,
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
      @authn_request_attributes[:force_authn] = true if authn_context > Spid::L1
      @authn_request_attributes
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    def authn_request
      AuthnRequest.new
    end

    def saml_settings
      ::OneLogin::RubySaml::Settings.new authn_request_attributes
    end

    private

    def protocol_binding
      "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
    end

    def name_identifier_format
      "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
    end
  end
end
