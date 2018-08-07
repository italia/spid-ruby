# frozen_string_literal: true

require "rexml/document"

module Spid
  module Saml2
    class AuthnRequest # :nodoc:
      attr_reader :document
      attr_reader :uuid
      attr_reader :settings

      def initialize(uuid: nil, settings:)
        @document = REXML::Document.new
        @uuid = uuid || SecureRandom.uuid
        @settings = settings
      end

      def to_saml
        document.add_element(
          "samlp:AuthnRequest",
          "xmlns:samlp" => "urn:oasis:names:tc:SAML:2.0:protocol",
          "xmlns:saml" => "urn:oasis:names:tc:SAML:2.0:assertion",
          "ID" => "_#{uuid}",
          "Version" => "2.0",
          "IssueInstant" => issue_instant,
          "Destination" => settings.idp_entity_id
        )
        document
      end

      def issue_instant
        @issue_instant ||= Time.now.utc.iso8601
      end
    end
  end
end
