# frozen_string_literal: true

require "spid/saml2/utils"

module Spid
  module Saml2
    class Response # :nodoc:
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
        document.elements["/samlp:Response/saml:Issuer/text()"]&.value
      end

      def name_id
        document.elements[
          "/samlp:Response/saml:Assertion/saml:Subject/saml:NameID/text()"
        ]&.value
      end

      def assertion_issuer
        document.elements[
          "/samlp:Response/saml:Assertion/saml:Issuer/text()"
        ]&.value
      end

      def session_index
        document.elements[
          "/samlp:Response/saml:Assertion/saml:AuthnStatement/@SessionIndex"
        ]&.value
      end

      def destination
        document.elements[
          "/samlp:Response/@Destination"
        ]&.value
      end

      def attributes
        main_xpath = "/samlp:Response/saml:Assertion/saml:AttributeStatement"
        main_xpath = "#{main_xpath}/saml:Attribute"

        attributes = REXML::XPath.match(document, main_xpath)
        attributes.each_with_object({}) do |attribute, acc|
          xpath = attribute.xpath

          name = document.elements["#{xpath}/@Name"].value
          value = document.elements["#{xpath}/saml:AttributeValue/text()"].value

          acc[name] = value
        end
      end
    end
  end
end
