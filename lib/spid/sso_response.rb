# frozen_string_literal: true

require "onelogin/ruby-saml/response"

module Spid
  class SsoResponse # :nodoc:
    attr_reader :body, :sso_settings

    def initialize(body:, sso_settings:)
      @body = body
      @sso_settings = sso_settings
    end

    def valid?
      saml_response.is_valid?
    end

    private

    def saml_response
      @saml_response ||= ::OneLogin::RubySaml::Response.new(
        body,
        settings: sso_settings
      )
    end
  end
end
