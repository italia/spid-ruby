# frozen_string_literal: true

require "spid/authn_request"
require "onelogin/ruby-saml/settings"

module Spid
  module Sso
    class Request # :nodoc:
      attr_reader :sso_settings

      def initialize(sso_settings:)
        @sso_settings = sso_settings
      end

      def to_saml
        authn_request.create(sso_settings)
      end

      private

      def authn_request
        AuthnRequest.new
      end
    end
  end
end
