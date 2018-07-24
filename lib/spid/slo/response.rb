# frozen_string_literal: true

require "onelogin/ruby-saml/logoutresponse"

module Spid
  module Slo
    class Response # :nodoc:
      attr_reader :body, :slo_settings

      def initialize(body:, slo_settings:)
        @body = body
        @slo_settings = slo_settings
      end

      def valid?
        saml_response.validate
      end

      private

      def saml_response
        @saml_response ||= ::OneLogin::RubySaml::Logoutresponse.new(
          body,
          slo_settings
        )
      end
    end
  end
end
