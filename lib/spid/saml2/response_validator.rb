# frozen_string_literal: true

require "xmldsig"

module Spid
  module Saml2
    class ResponseValidator # :nodoc:
      attr_reader :response
      attr_reader :settings

      def initialize(response:, settings:)
        @response = response
        @settings = settings
      end

      def call
        [
          issuer,
          certificate,
          destination,
          conditions,
          audience,
          signature
        ].all?
      end

      def issuer
        response.assertion_issuer == settings.idp_entity_id
      end

      def certificate
        response.certificate == settings.idp_certificate
      end

      def destination
        response.destination == settings.sp_acs_url
      end

      def conditions
        time = Time.now.iso8601

        response.conditions_not_before <= time &&
          response.conditions_not_on_or_after > time
      end

      def audience
        response.audience == settings.sp_entity_id
      end

      def signature
        signed_document = Xmldsig::SignedDocument.new(response.saml_message)
        signed_document.validate(response.certificate)
      end
    end
  end
end
