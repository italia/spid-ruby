# frozen_string_literal: true

module Spid
  module Saml2
    class IdpLogoutRequest # :nodoc:
      attr_reader :saml_message
      attr_reader :document

      def initialize(saml_message:)
        @saml_message = saml_message
        @document = REXML::Document.new(@saml_message)
      end

      def id
        document.elements["/samlp:LogoutRequest/@ID"]&.value
      end

      def destination
        document.elements["/samlp:LogoutRequest/@Destination"]&.value
      end

      def issue_instant
        document.elements["/samlp:LogoutRequest/@IssueInstant"]&.value
      end

      def issuer_name_qualifier
        document.elements[
          "/samlp:LogoutRequest/saml:Issuer/@NameQualifier"
        ]&.value
      end

      def name_id_name_qualifier
        document.elements[
          "/samlp:LogoutRequest/saml:NameID/@NameQualifier"
        ]&.value
      end

      def issuer
        document.elements["/samlp:LogoutRequest/saml:Issuer/text()"]&.value
      end

      def session_index
        document.elements[
          "/samlp:LogoutRequest/saml:SessionIndex/text()"
        ]&.value
      end
    end
  end
end
