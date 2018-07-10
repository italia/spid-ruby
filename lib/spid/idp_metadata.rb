# frozen_string_literal: true

require "singleton"
require "onelogin/ruby-saml/idp_metadata_parser"

module Spid
  class IdpMetadata # :nodoc:
    include Singleton

    def initialize
      @identity_providers = Spid::IdentityProviders.fetch_all
      @metadata = {}
    end

    def [](idp_name)
      return @metadata[idp_name] unless @metadata[idp_name].nil?
      idp_hash = identity_provider_hash(idp_name)

      @metadata[idp_name] = parser.parse_remote_to_hash(
        idp_hash[:metadata_url],
        idp_hash[:metadata_url].start_with?("https://")
      )
      @metadata[idp_name]
    end

    def identity_provider_hash(idp_name)
      @identity_providers.find do |idp|
        idp[:name] == idp_name.to_s
      end
    end

    private

    def parser
      @parser ||= ::OneLogin::RubySaml::IdpMetadataParser.new
    end
  end
end
