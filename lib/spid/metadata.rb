# frozen_string_literal: true

require "onelogin/ruby-saml/metadata"
require "onelogin/ruby-saml/settings"

module Spid
  class Metadata # :nodoc:
    attr_reader :metadata_attributes,
                :service_provider,
                :attribute_service_name

    # rubocop:disable Metrics/MethodLength
    def initialize(
          service_provider:,
          attribute_service_name:,
          digest_method: Spid::SHA256,
          signature_method: Spid::RSA_SHA256
        )
      @service_provider = service_provider
      @attribute_service_name = attribute_service_name
      @metadata_attributes = {
        issuer: issuer,
        private_key: private_key_content,
        certificate: certificate_content,
        assertion_consumer_service_url: assertion_consumer_service_url,
        single_logout_service_url: single_logout_service_url,
        security: {
          authn_requests_signed:     true,
          logout_requests_signed:    false,
          logout_responses_signed:   false,
          want_assertions_signed:    false,
          want_assertions_encrypted: false,
          want_name_id:              false,
          metadata_signed:           true,
          embed_sign:                false,
          digest_method:             digest_method,
          signature_method:          signature_method
        }
      }
    end
    # rubocop:enable Metrics/MethodLength

    def to_xml
      metadata.generate(saml_settings)
    end

    def issuer
      service_provider.host
    end

    def private_key_content
      service_provider.private_key
    end

    def certificate_content
      service_provider.certificate
    end

    def assertion_consumer_service_url
      service_provider.sso_url
    end

    def single_logout_service_url
      service_provider.slo_url
    end

    private

    def metadata
      ::OneLogin::RubySaml::Metadata.new
    end

    def saml_settings
      @saml_settings = ::OneLogin::RubySaml::Settings.new metadata_attributes

      outer_self = self

      @saml_settings.attribute_consuming_service.configure do
        service_index 0
        service_name outer_self.attribute_service_name
        add_attribute name: "Name",
                      name_format: "Name Format",
                      friendly_name: "Friendly Name"
      end

      @saml_settings
    end
  end
end
