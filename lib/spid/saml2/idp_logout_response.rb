# frozen_string_literal: true

module Spid
  module Saml2
    class IdpLogoutResponse # :nodoc:
      attr_reader :document
      attr_reader :settings

      def initialize(settings:)
        @document = REXML::Document.new
        @settings = settings
      end

      def to_saml
        document.add_element(logout_response)
        document.to_s
      end

      def logout_response
        @logout_response ||=
          begin
            element = REXML::Element.new("samlp:LogoutResponse")
            element.add_attributes(logout_response_attributes)
            element.add_element(issuer)
            element.add_element(status)
            element
          end
      end

      def logout_response_attributes
        @logout_response_attributes ||= {
          "xmlns:samlp" => "urn:oasis:names:tc:SAML:2.0:protocol",
          "xmlns:saml" => "urn:oasis:names:tc:SAML:2.0:assertion"
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

      def status
        @status ||=
          begin
            element = REXML::Element.new("saml:Status")
            element.add_element(status_code)
            element
          end
      end

      def status_code
        @status_code ||=
          begin
            element = REXML::Element.new("saml:StatusCode")
            element.text = "urn:oasis:names:tc:SAML:2.0:status:Success"
            element
          end
      end
    end
  end
end
