# frozen_string_literal: true

module Spid
  module Saml2
    class Response < SamlParser # :nodoc:
      def issuer
        document.elements["/samlp:Response/saml:Issuer/text()"]&.value
      end

      def in_response_to
        document.elements["/samlp:Response/@InResponseTo"]&.value
      end

      def name_id
        element_from_xpath(
          "/samlp:Response/saml:Assertion/saml:Subject/saml:NameID/text()"
        )
      end

      def raw_certificate
        element_from_xpath(
          "/samlp:Response/saml:Assertion/ds:Signature/ds:KeyInfo" \
          "/ds:X509Data/ds:X509Certificate/text()"
        )
      end

      def certificate
        certificate_from_encoded_der(raw_certificate)
      end

      def assertion_issuer
        element_from_xpath("/samlp:Response/saml:Assertion/saml:Issuer/text()")
      end

      def session_index
        element_from_xpath(
          "/samlp:Response/saml:Assertion/saml:AuthnStatement/@SessionIndex"
        )
      end

      def destination
        element_from_xpath("/samlp:Response/@Destination")
      end

      def conditions_not_before
        element_from_xpath(
          "/samlp:Response/saml:Assertion/saml:Conditions/@NotBefore"
        )
      end

      def conditions_not_on_or_after
        element_from_xpath(
          "/samlp:Response/saml:Assertion/saml:Conditions/@NotOnOrAfter"
        )
      end

      def audience
        element_from_xpath(
          "/samlp:Response/saml:Assertion/saml:Conditions" \
          "/saml:AudienceRestriction/saml:Audience/text()"
        )
      end

      def subject_confirmation_data_node_xpath
        xpath = "/samlp:Response/saml:Assertion/saml:Subject/"
        "#{xpath}/saml:SubjectConfirmation/saml:SubjectConfirmationData"
      end

      def subject_recipient
        element_from_xpath("#{subject_confirmation_data_node_xpath}/@Recipient")
      end

      def subject_in_response_to
        element_from_xpath(
          "#{subject_confirmation_data_node_xpath}/@InResponseTo"
        )
      end

      def subject_not_on_or_after
        element_from_xpath(
          "#{subject_confirmation_data_node_xpath}/@NotOnOrAfter"
        )
      end

      def status_code
        element_from_xpath(
          "/samlp:Response/samlp:Status/samlp:StatusCode/@Value"
        )
      end

      def status_message
        element_from_xpath(
          "samlp:StatusMessage/@Value" \
          "/samlp:Response/samlp:Status/samlp:StatusCode/"
        )
      end

      def status_detail
        element_from_xpath(
          "/samlp:Response/samlp:Status/samlp:StatusCode/" \
          "samlp:StatusDetail/@Value"
        )
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
