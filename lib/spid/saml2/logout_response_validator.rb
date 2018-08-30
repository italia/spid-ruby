# frozen_string_literal: true

module Spid
  module Saml2
    class LogoutResponseValidator # :nodoc:
      attr_reader :response
      attr_reader :settings
      attr_reader :request_uuid
      attr_reader :errors

      def initialize(response:, settings:, request_uuid:)
        @response = response
        @settings = settings
        @request_uuid = request_uuid
        @errors = {}
      end

      def call
        [
          matches_request_uuid,
          destination,
          issuer
        ].all?
      end

      def matches_request_uuid
        return true if response.in_response_to == request_uuid

        @errors["request_uuid_mismatch"] =
          "Request uuid not belongs to current session"
        false
      end

      def destination
        return true if response.destination == settings.sp_slo_service_url

        @errors["destination"] =
          begin
            "Response Destination is '#{response.destination}'" \
            " but was expected '#{settings.sp_slo_service_url}'"
          end
        false
      end

      def issuer
        return true if response.issuer == settings.idp_entity_id

        @errors["issuer"] =
          begin
            "Response Issuer is '#{response.issuer}'" \
            " but was expected '#{settings.idp_entity_id}'"
          end
        false
      end
    end
  end
end
