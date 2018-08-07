# frozen_string_literal: true

module Spid
  class IdentityProviderManager # :nodoc:
    include Singleton

    def identity_providers
      @identity_providers ||=
        begin
          Dir.chdir(Spid.configuration.idp_metadata_dir_path) do
            Dir.glob("*.xml").map do |metadata_filepath|
              generate_identity_provider_from_file(
                File.expand_path(metadata_filepath)
              )
            end
          end
        end
    end

    def self.find_by_name(idp_name)
      instance.identity_providers.find do |idp|
        idp.name == idp_name
      end
    end

    def self.find_by_entity(entity_id)
      instance.identity_providers.find do |idp|
        idp.entity_id == entity_id
      end
    end

    private

    def generate_identity_provider_from_file(metadata_filepath)
      idp_name = File.basename(metadata_filepath, "-metadata.xml")
      metadata = File.read(metadata_filepath)
      ::Spid::Saml2::IdentityProvider.parse_from_xml(
        metadata: metadata,
        name: idp_name
      )
    end
  end
end
