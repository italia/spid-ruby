# frozen_string_literal: true

require "onelogin/ruby-saml/idp_metadata_parser"

module Spid
  class IdentityProvider # :nodoc:
    attr_reader :name,
                :entity_id,
                :sso_target_url,
                :slo_target_url,
                :cert_fingerprint

    def initialize(
          name:,
          entity_id:,
          sso_target_url:,
          slo_target_url:,
          cert_fingerprint:
        )
      @name = name
      @entity_id = entity_id
      @sso_target_url = sso_target_url
      @slo_target_url = slo_target_url
      @cert_fingerprint = cert_fingerprint
    end

    def sso_attributes
      @sso_attributes ||=
        begin
          {
            idp_sso_target_url: sso_target_url,
            idp_cert_fingerprint: cert_fingerprint
          }
        end
    end

    def slo_attributes
      @slo_attributes ||=
        begin
          {
            idp_slo_target_url: slo_target_url,
            idp_name_qualifier: entity_id,
            idp_cert_fingerprint: cert_fingerprint
          }
        end
    end

    def self.parse_from_xml(name:, metadata:)
      idp_metadata_parser = ::OneLogin::RubySaml::IdpMetadataParser.new
      idp_settings = idp_metadata_parser.parse_to_hash(metadata)
      new(
        name: name,
        entity_id: idp_settings[:idp_entity_id],
        sso_target_url: idp_settings[:idp_sso_target_url],
        slo_target_url: idp_settings[:idp_slo_target_url],
        cert_fingerprint: idp_settings[:idp_cert_fingerprint]
      )
    end
  end
end
