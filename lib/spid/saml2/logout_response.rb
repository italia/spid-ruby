# frozen_string_literal: true

require "spid/saml2/utils"

module Spid
  module Saml2
    class LogoutResponse < SamlParser # :nodoc:
      def issuer
        element_from_xpath("/samlp:LogoutResponse/saml:Issuer/text()")
      end

      def in_response_to
        element_from_xpath("/samlp:LogoutResponse/@InResponseTo")
      end

      def destination
        element_from_xpath("/samlp:LogoutResponse/@Destination")
      end
    end
  end
end
