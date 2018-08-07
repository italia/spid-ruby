# frozen_string_literal: true

require "rexml/document"

module Spid
  module Saml2
    class AuthnRequest # :nodoc:
      attr_reader :document
      attr_reader :uuid

      def initialize(uuid: nil)
        @document = REXML::Document.new
        @uuid = uuid || SecureRandom.uuid
      end

      def to_saml
        document.add_element(
          "samlp:AuthnRequest",
          "xmlns:samlp" => "urn:oasis:names:tc:SAML:2.0:protocol",
          "xmlns:saml" => "urn:oasis:names:tc:SAML:2.0:assertion",
          "ID" => "_#{uuid}",
          "Version" => "2.0",
          "IssueInstant" => issue_instant
        )
        document
      end

      def issue_instant
        @issue_instant ||= Time.now.utc.iso8601
      end
    end
  end
end
