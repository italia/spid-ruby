# frozen_string_literal: true

require "spid/saml2/utils"
require "active_support/inflector/methods"

module Spid
  module Sso
    class Response # :nodoc:
      include Spid::Saml2::Utils

      attr_reader :body
      attr_reader :saml_message

      def initialize(body:)
        @body = body
        @saml_message = decode_and_inflate(body)
      end

      def valid?
        saml_response.destination == service_provider.acs_url
      end

      def issuer
        saml_response.assertion_issuer
      end

      def attributes
        raw_attributes.each_with_object({}) do |(key, value), acc|
          acc[normalize_key(key)] = value
        end
      end

      def session_index
        saml_response.session_index
      end

      def raw_attributes
        saml_response.attributes
      end

      def identity_provider
        @identity_provider ||=
          IdentityProviderManager.find_by_entity(issuer)
      end

      def service_provider
        @service_provider ||=
          Spid.configuration.service_provider
      end

      def saml_response
        @saml_response ||= Spid::Saml2::Response.new(saml_message: saml_message)
      end

      private

      def normalize_key(key)
        ActiveSupport::Inflector.underscore(
          key.to_s
        ).to_s
      end
    end
  end
end
