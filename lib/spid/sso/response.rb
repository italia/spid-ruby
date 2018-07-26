# frozen_string_literal: true

require "onelogin/ruby-saml/response"
require "active_support/inflector/methods"

module Spid
  module Sso
    class Response # :nodoc:
      attr_reader :body

      def initialize(body:)
        @body = body
      end

      def valid?
        validated_saml_response.is_valid?
      end

      def saml_settings
        sso_settings.saml_settings
      end

      def sso_settings
        Settings.new(
          service_provider: service_provider,
          identity_provider: identity_provider
        )
      end

      def attributes
        raw_attributes.each_with_object({}) do |(key, value), acc|
          acc[normalize_key(key)] = value
        end
      end

      def issuer
        saml_response.issuers.first
      end

      def session_index
        saml_response.sessionindex
      end

      def raw_attributes
        saml_response.attributes.attributes
      end

      def identity_provider
        @identity_provider ||=
          IdentityProviderManager.find_by_entity(issuer)
      end

      def service_provider
        @service_provider ||=
          Spid.configuration.service_provider
      end

      private

      def normalize_key(key)
        ActiveSupport::Inflector.underscore(
          key.to_s
        ).to_sym
      end

      def saml_response
        ::OneLogin::RubySaml::Response.new(body)
      end

      def validated_saml_response
        @validated_saml_response ||=
          begin
            response = saml_response
            response.settings = saml_settings
            response
          end
      end
    end
  end
end
