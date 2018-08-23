# frozen_string_literal: true

module Spid
  class Metadata # :nodoc:
    attr_reader :sp_metadata

    def initialize
      @sp_metadata = Spid::Saml2::SPMetadata.new(settings: settings)
    end

    def settings
      @settings ||= Spid::Saml2::Settings.new(
        service_provider: service_provider,
        identity_provider: nil
      )
    end

    def to_xml
      sp_metadata.to_saml
    end

    def service_provider
      @service_provider ||= Spid.configuration.service_provider
    end
  end
end
