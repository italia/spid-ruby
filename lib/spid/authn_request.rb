# frozen_string_literal: true

require "onelogin/ruby-saml/authrequest"
require "onelogin/ruby-saml/settings"

module Spid
  class AuthnRequest # :nodoc:
    def initialize(idp_sso_target_url:)
    end

    def to_xml
      authn_request.create_xml_document(saml_settings)
    end

    private

    def authn_request
      OneLogin::RubySaml::Authrequest.new
    end

    def saml_settings
      OneLogin::RubySaml::Settings.new
    end
  end
end
