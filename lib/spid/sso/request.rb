# frozen_string_literal: true

require "spid/authn_request"
require "onelogin/ruby-saml/settings"

module Spid
  module Sso
    class Request # :nodoc:
      attr_reader :idp_name
      attr_reader :authn_context
      attr_reader :authn_context_comparison

      def initialize(idp_name:, authn_context:, authn_context_comparison:)
        @idp_name = idp_name
        @authn_context = authn_context
        @authn_context_comparison = authn_context_comparison
      end

      def to_saml
        authn_request.create(saml_settings)
      end

      def saml_settings
        sso_settings.saml_settings
      end

      def sso_settings
        Settings.new(
          service_provider: service_provider,
          identity_provider: identity_provider,
          authn_context: authn_context,
          authn_context_comparison: authn_context_comparison
        )
      end

      def identity_provider
        @identity_provider ||=
          IdentityProviderManager.find_by_name(idp_name)
      end

      def service_provider
        @service_provider ||=
          Spid.configuration.service_provider
      end

      private

      def authn_request
        AuthnRequest.new
      end
    end
  end
end
