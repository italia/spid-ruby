# frozen_string_literal: true

module Spid
  module Saml2
    class LogoutResponseValidator # :nodoc:
      attr_reader :response
      attr_reader :settings
      attr_reader :request_uuid

      def initialize(response:, settings:, request_uuid:)
        @response = response
        @settings = settings
        @request_uuid = request_uuid
      end

      def call
        [
          matches_request_uuid,
          destination,
          issuer
        ].all?
      end

      def matches_request_uuid
        response.in_response_to == request_uuid
      end

      def destination
        response.destination == settings.sp_slo_service_url
      end

      def issuer
        response.issuer == settings.idp_entity_id
      end
    end
  end
end
