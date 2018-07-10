# frozen_string_literal: true

require "spid/authn_request"
require "onelogin/ruby-saml/settings"

module Spid
  class SsoRequest # :nodoc:
    attr_reader :authn_request_attributes,
                :service_provider_configuration

    # rubocop:disable Metrics/MethodLength
    def initialize(
          idp_sso_target_url:,
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
      @authn_request_attributes = {
        idp_sso_target_url: idp_sso_target_url,
        assertion_consumer_service_url: assertion_consumer_service_url,
        protocol_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST",
        issuer: issuer,
        private_key: private_key_content,
        certificate: certificate_content,
        name_identifier_format: name_identifier_format,
        authn_context: authn_context,
        authn_context_comparison: authn_context_comparison,
        security: {
          authn_requests_signed: true,
          embed_sign: true,
          digest_method: digest_method,
          signature_method: signature_method
        }
      }

      return if authn_context <= Spid::L1
      @authn_request_attributes[:force_authn] = true
    end

    # rubocop:enable Metrics/MethodLength

    def to_saml
      authn_request.create(saml_settings)
    end

    def assertion_consumer_service_url
      service_provider_configuration.sso_url
    end

    def issuer
      service_provider_configuration.host
    end

    def private_key_content
      service_provider_configuration.private_key
    end

    def certificate_content
      service_provider_configuration.certificate
    end

    def digest_method
      service_provider_configuration.digest_method
    end

    def signature_method
      service_provider_configuration.signature_method
    end

    private

    def name_identifier_format
      "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
    end

    def authn_request
      AuthnRequest.new
    end

    def saml_settings
      ::OneLogin::RubySaml::Settings.new authn_request_attributes
    end
  end
end
