# frozen_string_literal: true

require "onelogin/ruby-saml/metadata"
require "onelogin/ruby-saml/settings"

module Spid
  class Metadata # :nodoc:
    attr_reader :metadata_attributes

    # rubocop:disable Metrics/MethodLength
    def initialize(
          issuer:,
          private_key_filepath:,
          certificate_filepath:,
          digest_method: Spid::SHA256,
          signature_method: Spid::RSA_SHA256
        )
      @metadata_attributes = {
        issuer: issuer,
        private_key: File.read(private_key_filepath),
        certificate: File.read(certificate_filepath),
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

    private

    def metadata
      ::OneLogin::RubySaml::Metadata.new
    end

    def saml_settings
      ::OneLogin::RubySaml::Settings.new metadata_attributes
    end
  end
end
