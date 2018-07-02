# frozen_string_literal: true

require "onelogin/ruby-saml/metadata"
require "onelogin/ruby-saml/settings"

module Spid
  class Metadata # :nodoc:
    attr_reader :metadata_settings

    def initialize
      @metadata_settings = {}
    end

    def to_xml
      metadata.generate(saml_settings)
    end

    private

    def metadata
      ::OneLogin::RubySaml::Metadata.new
    end

    def saml_settings
      ::OneLogin::RubySaml::Settings.new metadata_settings
    end
  end
end
