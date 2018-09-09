# frozen_string_literal: true

module Spid
  module Saml2
    class IdpLogoutRequest < SamlParser # :nodoc:
      def id
        element_from_xpath("/samlp:LogoutRequest/@ID")
      end

      def destination
        element_from_xpath("/samlp:LogoutRequest/@Destination")
      end

      def issue_instant
        element_from_xpath("/samlp:LogoutRequest/@IssueInstant")
      end

      def issuer_name_qualifier
        element_from_xpath("/samlp:LogoutRequest/saml:Issuer/@NameQualifier")
      end

      def name_id
        element_from_xpath("/samlp:LogoutRequest/saml:NameID/text()")
      end

      def name_id_name_qualifier
        element_from_xpath("/samlp:LogoutRequest/saml:NameID/@NameQualifier")
      end

      def issuer
        element_from_xpath("/samlp:LogoutRequest/saml:Issuer/text()")
      end

      def session_index
        element_from_xpath("/samlp:LogoutRequest/saml:SessionIndex/text()")
      end
    end
  end
end
