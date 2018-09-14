# frozen_string_literal: true

require "base64"

module Spid
  class IdentityProviderManager # :nodoc:
    include Singleton

    def identity_providers
      @identity_providers ||=
        begin
          Dir.chdir(Spid.configuration.idp_metadata_dir_path) do
            Dir.glob("*.xml").map do |metadata_filepath|
              ::Spid::Saml2::IdentityProvider.new(
                metadata: File.read(File.expand_path(metadata_filepath))
              )
            end
          end
        end
    end

    def self.find_by_entity(entity_id)
      instance.identity_providers.find do |idp|
        idp.entity_id == entity_id
      end
    end
  end
end
