# frozen_string_literal: true

require "spid/saml2/utils"

module Spid
  module Saml2
    class LogoutResponse # :nodoc:
      include Spid::Saml2::Utils

      attr_reader :body
      attr_reader :saml_message
      attr_reader :document

      def initialize(body:)
        @body = body
        @saml_message = decode_and_inflate(body)
        @document = REXML::Document.new(@saml_message)
      end

      def issuer
        document.elements[
          "/samlp:LogoutResponse/saml:Issuer/text()"
        ]&.value&.strip
      end

      def in_response_to
        document.elements[
          "/samlp:LogoutResponse/@InResponseTo"
        ]&.value&.strip
      end
    end
  end
end
