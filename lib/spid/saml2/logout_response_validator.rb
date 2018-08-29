# frozen_string_literal: true

module Spid
  module Saml2
    class LogoutResponseValidator
      attr_reader :response
      attr_reader :settings

      def initialize(response:, settings:)
        @response = response
        @settings = settings
      end

      def call
        [
          destination
        ].all?
      end

      def destination
        response.destination == settings.sp_slo_service_url
      end
    end
  end
end
