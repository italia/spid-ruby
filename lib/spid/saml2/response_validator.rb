# frozen_string_literal: true

module Spid
  module Saml2
    class ResponseValidator # :nodoc:
      attr_reader :response
      attr_reader :settings

      def initialize(response:, settings:)
        @response = response
        @settings = settings
      end

      def issuer
        response.assertion_issuer == settings.idp_entity_id
      end
    end
  end
end
