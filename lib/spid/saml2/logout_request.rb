# frozen_string_literal: true

module Spid
  module Saml2
    class LogoutRequest # :nodoc:
      attr_reader :settings
      attr_reader :uuid
      attr_reader :document
      attr_reader :session_index

      def initialize(uuid: nil, settings:, session_index:)
        @settings = settings
        @document = REXML::Document.new
        @session_index = session_index
        @uuid = uuid || SecureRandom.uuid
      end

      def to_saml
        document.add_element(logout_request)
        document.to_s
      end

      def logout_request
        @logout_request ||=
          begin
            element = REXML::Element.new("samlp:LogoutRequest")
            element.add_attributes(logout_request_attributes)
            element.add_element(issuer)
            element.add_element(name_id)
            element.add_element(samlp_session_index)
            element
          end
      end

      def logout_request_attributes
        @logout_request_attributes ||= {
          "xmlns:samlp" => "urn:oasis:names:tc:SAML:2.0:protocol",
          "xmlns:saml" => "urn:oasis:names:tc:SAML:2.0:assertion",
          "ID" => "_#{uuid}",
          "Version" => "2.0",
          "IssueInstant" => issue_instant,
          "Destination" => settings.idp_entity_id
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

      def name_id
        @name_id ||=
          begin
            element = REXML::Element.new("saml:NameID")
            element.add_attributes(
              "Format" => "urn:oasis:names:tc:SAML:2.0:nameid-format:transient",
              "NameQualifier" => settings.idp_entity_id
            )
            element.text = "a-name-identifier-value"
            element
          end
      end

      def samlp_session_index
        @samlp_session_index ||=
          begin
            element = REXML::Element.new("samlp:SessionIndex")
            element.text = session_index
            element
          end
      end

      private

      def issue_instant
        @issue_instant ||= Time.now.utc.iso8601
      end
    end
  end
end
