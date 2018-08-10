# frozen_string_literal: true

module Spid
  module Saml2
    class SPMetadata # :nodoc:
      attr_reader :document
      attr_reader :settings

      def initialize(settings:)
        @document = REXML::Document.new
        @settings = settings
      end

      def to_saml
        document.add_element(entity_descriptor)
        document.to_s
      end

      def entity_descriptor
        @entity_descriptor ||=
          begin
            element = REXML::Element.new("md:EntityDescriptor")
            element.add_attributes(entity_descriptor_attributes)
            element
          end
      end

      def entity_descriptor_attributes
        @entity_descriptor_attributes ||= {
          "xmlns:md" => "urn:oasis:names:tc:SAML:2.0:metadata",
          "EntityID" => settings.sp_entity_id
        }
      end
    end
  end
end
