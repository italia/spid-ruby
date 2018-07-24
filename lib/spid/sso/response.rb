# frozen_string_literal: true

require "onelogin/ruby-saml/response"
require "active_support/inflector/methods"

module Spid
  module Sso
    class Response # :nodoc:
      attr_reader :body, :sso_settings

      def initialize(body:, sso_settings:)
        @body = body
        @sso_settings = sso_settings
      end

      def valid?
        saml_response.is_valid?
      end

      def attributes
        raw_attributes.each_with_object({}) do |(key, value), acc|
          acc[normalize_key(key)] = value
        end
      end

      def session_index
        saml_response.sessionindex
      end

      def raw_attributes
        saml_response.attributes.attributes
      end

      private

      def normalize_key(key)
        ActiveSupport::Inflector.underscore(
          key.to_s
        ).to_sym
      end

      def saml_response
        @saml_response ||= ::OneLogin::RubySaml::Response.new(
          body,
          settings: sso_settings
        )
      end
    end
  end
end
