# frozen_string_literal: true

require "uri"

module Spid
  module Saml2
    class ServiceProvider # :nodoc:
      attr_reader :host
      attr_reader :acs_path
      attr_reader :acs_binding
      attr_reader :slo_path
      attr_reader :slo_binding
      attr_reader :metadata_path
      attr_reader :private_key
      attr_reader :certificate
      attr_reader :digest_method
      attr_reader :signature_method
      attr_reader :attribute_service_name

      # rubocop:disable Metrics/ParameterLists
      # rubocop:disable Metrics/MethodLength
      def initialize(
            host:,
            acs_path:,
            acs_binding:,
            slo_path:,
            slo_binding:,
            metadata_path:,
            private_key:,
            certificate:,
            digest_method:,
            signature_method:,
            attribute_service_name:
          )
        @host = host
        @acs_path               = acs_path
        @acs_binding            = acs_binding
        @slo_path               = slo_path
        @slo_binding            = slo_binding
        @metadata_path          = metadata_path
        @private_key            = private_key
        @certificate            = certificate
        @digest_method          = digest_method
        @signature_method       = signature_method
        @attribute_service_name = attribute_service_name
        validate_attributes
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/ParameterLists

      def acs_url
        @acs_url ||= URI.join(host, acs_path).to_s
      end

      def slo_url
        @slo_url ||= URI.join(host, slo_path).to_s
      end

      def metadata_url
        @metadata_url ||= URI.join(host, metadata_path).to_s
      end

      private

      def validate_attributes
        if !DIGEST_METHODS.include?(digest_method)
          raise UnknownDigestMethodError,
                "Provided digest method is not valid:" \
                " use one of #{DIGEST_METHODS.join(', ')}"
        elsif !SIGNATURE_METHODS.include?(signature_method)
          raise UnknownSignatureMethodError,
                "Provided digest method is not valid:" \
                " use one of #{SIGNATURE_METHODS.join(', ')}"
        end
      end
    end
  end
end
