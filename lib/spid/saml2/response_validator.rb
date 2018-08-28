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

      def destination
        response.destination == settings.sp_entity_id
      end

      def conditions
        time = Time.now.iso8601

        response.conditions_not_before <= time &&
          response.conditions_not_on_or_after > time
      end

      def audience
        response.audience == settings.sp_entity_id
      end
    end
  end
end
