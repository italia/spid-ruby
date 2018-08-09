# frozen_string_literal: true

module Spid
  module Saml2
    class LogoutRequest # :nodoc:
      attr_reader :document

      def initialize(uuid: nil)
        @document = REXML::Document.new
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
            element
          end
      end

      def logout_request_attributes
        @logout_request_attributes ||=
          begin
            attributes = {
              "xmlns:samlp" => "urn:oasis:names:tc:SAML:2.0:protocol",
              "xmlns:saml" => "urn:oasis:names:tc:SAML:2.0:assertion"
            }
            attributes
          end
      end
    end
  end
end
