# frozen_string_literal: true

module Spid
  class IdentityProviderConfiguration # :nodoc:
    attr_reader :idp_metadata, :idp_metadata_hash

    def initialize(idp_metadata:)
      @idp_metadata = idp_metadata
      @idp_metadata_hash = idp_metadata_parser.parse_to_hash(idp_metadata)
    end

    def entity_id
      @entity_id ||= idp_metadata_hash[:idp_entity_id]
    end

    private

    def idp_metadata_parser
      @idp_metadata_parser ||= ::OneLogin::RubySaml::IdpMetadataParser.new
    end
  end
end
