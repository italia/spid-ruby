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
        document.add_element(authn_request)
        document
      end

      def authn_request
        @authn_request ||=
          begin
            element = REXML::Element.new("samlp:AuthnRequest")
            element.add_attributes(authn_request_attributes)
            element.add_element(issuer)
            element.add_element(name_id_policy)
            element
          end
      end

      def authn_request_attributes
        @authn_request_attributes ||= {
          "xmlns:samlp" => "urn:oasis:names:tc:SAML:2.0:protocol",
          "xmlns:saml" => "urn:oasis:names:tc:SAML:2.0:assertion",
          "ID" => "_#{uuid}",
          "Version" => "2.0",
          "IssueInstant" => issue_instant,
          "Destination" => settings.idp_entity_id,
          "AssertionConsumerServiceIndex" => settings.acs_index
        }
      end

      def issuer
        @issuer ||=
          begin
            element = REXML::Element.new("saml:Issuer")
            element.add_attributes(
              "Format" => "urn:oasis:names:tc:SAML:2.0:nameid-format:entity",
              "NameQualifier" => settings.sp_entity_id
            )
            element.text = settings.sp_entity_id
            element
          end
      end

      def name_id_policy
        @name_id_policy ||=
          begin
            element = REXML::Element.new("samlp:NameIDPolicy")
            element.add_attributes(
              "Format" => "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
            )
            element
          end
      end

      def issue_instant
        @issue_instant ||= Time.now.utc.iso8601
      end
    end
  end
end
