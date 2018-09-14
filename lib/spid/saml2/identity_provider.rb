# frozen_string_literal: true

module Spid
  module Saml2
    class IdentityProvider < SamlParser # :nodoc:
      def initialize(metadata:)
        super(saml_message: metadata)
      end

      def entity_id
        element_from_xpath(
          "/md:EntityDescriptor/@entityID"
        )
      end

      def sso_target_url
        element_from_xpath(
          "/md:EntityDescriptor/md:IDPSSODescriptor" \
          "/md:SingleSignOnService/@Location"
        )
      end

      def slo_target_url
        element_from_xpath(
          "/md:EntityDescriptor/md:IDPSSODescriptor" \
          "/md:SingleLogoutService/@Location"
        )
      end

      def raw_certificate
        element_from_xpath(
          "/md:EntityDescriptor/md:IDPSSODescriptor" \
          "/md:KeyDescriptor[@use='encryption']/ds:KeyInfo" \
          "/ds:X509Data/ds:X509Certificate/text()"
        )
      end

      def certificate
        certificate_from_encoded_der(raw_certificate)
      end
    end
  end
end
