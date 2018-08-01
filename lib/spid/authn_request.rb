# frozen_string_literal: true

require "onelogin/ruby-saml/authrequest"

module Spid
  class AuthnRequest < ::OneLogin::RubySaml::Authrequest # :nodoc:
    def create_xml_document(settings)
      original_document = super(settings)
      root = original_document.elements["//samlp:AuthnRequest"]
      name_id_policy_element = root.add_element("samlp:NameIDPolicy")
      name_id_policy_element.attributes["Format"] = format_transient
      issuer_element = original_document.elements["//saml:Issuer"]
      issuer_element.attributes["Format"] = format_entity
      issuer_element.attributes["NameQualifier"] = settings.issuer
      original_document
    end

    private

    def format_transient
      "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
    end

    def format_entity
      "urn:oasis:names:tc:SAML:2.0:nameid-format:entity"
    end
  end
end
