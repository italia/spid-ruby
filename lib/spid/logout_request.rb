# frozen_string_literal: true

require "onelogin/ruby-saml/logoutrequest"

module Spid
  class LogoutRequest < ::OneLogin::RubySaml::Logoutrequest # :nodoc:
    def create_xml_document(settings)
      original_document = super(settings)
      issuer_element = original_document.elements["//saml:Issuer"]
      issuer_element.attributes["Format"] = format_entity
      issuer_element.attributes["NameQualifier"] = settings.issuer
      original_document
    end

    private

    def format_entity
      "urn:oasis:names:tc:SAML:2.0:nameid-format:entity"
    end
  end
end
