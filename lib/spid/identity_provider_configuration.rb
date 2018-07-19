# frozen_string_literal: true

module Spid
  class IdentityProviderConfiguration # :nodoc:
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
