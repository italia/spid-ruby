# frozen_string_literal: true

require "onelogin/ruby-saml/logoutresponse"

module Spid
  module Slo
    class Response # :nodoc:
      attr_reader :body
      attr_reader :session_index
      attr_reader :matches_request_id

      def initialize(body:, session_index:, matches_request_id:)
        @body = body
        @session_index = session_index
        @matches_request_id = matches_request_id
      end

      def valid?
        saml_response.in_response_to == matches_request_id
      end

      def errors
        []
      end

      def identity_provider
        @identity_provider ||=
          IdentityProviderManager.find_by_entity(issuer)
      end

      def service_provider
        @service_provider ||=
          Spid.configuration.service_provider
      end

      def issuer
        saml_response.issuer
      end

      def saml_response
        @saml_response ||= Spid::Saml2::LogoutResponse.new(
          body: body
        )
      end

      private

      def saml_responseold
        ::OneLogin::RubySaml::Logoutresponse.new(
          body,
          nil,
          matches_request_id: matches_request_id
        )
      end
    end
  end
end
