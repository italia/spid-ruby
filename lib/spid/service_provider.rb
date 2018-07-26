# frozen_string_literal: true

require "uri"

module Spid
  class ServiceProvider # :nodoc:
    attr_reader :host,
                :acs_path,
                :slo_path,
                :metadata_path,
                :private_key,
                :certificate,
                :digest_method,
                :signature_method

    # rubocop:disable Metrics/ParameterLists
    def initialize(
          host:,
          acs_path:,
          slo_path:,
          metadata_path:,
          private_key:,
          certificate:,
          digest_method:,
          signature_method:
        )
      @host = host
      @acs_path = acs_path
      @slo_path = slo_path
      @metadata_path = metadata_path
      @private_key = private_key
      @certificate = certificate
      @digest_method = digest_method
      @signature_method = signature_method
      validate_attributes
    end
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

    # rubocop:disable Metrics/MethodLength
    def sso_attributes
      @sso_attributes ||=
        begin
          {
            assertion_consumer_service_url: acs_url,
            issuer: host,
            private_key: private_key,
            certificate: certificate,
            security: {
              authn_requests_signed: true,
              embed_sign: true,
              digest_method: digest_method,
              signature_method: signature_method
            }
          }
        end
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def slo_attributes
      @slo_attributes ||=
        begin
          {
            issuer: host,
            private_key: private_key,
            certificate: certificate,
            security: {
              logout_requests_signed: true,
              embed_sign: true,
              digest_method: digest_method,
              signature_method: signature_method
            }
          }
        end
    end
    # rubocop:enable Metrics/MethodLength

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
