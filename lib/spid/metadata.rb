# frozen_string_literal: true

require "onelogin/ruby-saml/metadata"
require "onelogin/ruby-saml/settings"

module Spid
  class Metadata # :nodoc:
    attr_reader :metadata_attributes,
                :attribute_service_name

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/ParameterLists
    def initialize(
          issuer:,
          private_key_filepath:,
          certificate_filepath:,
          assertion_consumer_service_url:,
          attribute_service_name:,
          digest_method: Spid::SHA256,
          signature_method: Spid::RSA_SHA256
        )
      @attribute_service_name = attribute_service_name
      @metadata_attributes = {
        issuer: issuer,
        private_key: File.read(private_key_filepath),
        certificate: File.read(certificate_filepath),
        assertion_consumer_service_url: assertion_consumer_service_url,
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
    # rubocop:enable Metrics/ParameterLists
    # rubocop:enable Metrics/MethodLength

    def to_xml
      metadata.generate(saml_settings)
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
