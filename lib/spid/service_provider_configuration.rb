# frozen_string_literal: true

require "uri"

module Spid
  class ServiceProviderConfiguration # :nodoc:
    attr_reader :host,
                :sso_path,
                :slo_path,
                :metadata_path,
                :private_key_file_path,
                :certificate_file_path,
                :digest_method,
                :signature_method

    # rubocop:disable Metrics/ParameterLists
    def initialize(
          host:,
          sso_path:,
          slo_path:,
          metadata_path:,
          private_key_file_path:,
          certificate_file_path:,
          digest_method:,
          signature_method:
        )
      @host = host
      @sso_path = sso_path
      @slo_path = slo_path
      @metadata_path = metadata_path
      @private_key_file_path = private_key_file_path
      @certificate_file_path = certificate_file_path
      @digest_method = digest_method
      @signature_method = signature_method
      validate_attributes
    end
    # rubocop:enable Metrics/ParameterLists

    def sso_url
      @sso_url ||= URI.join(host, sso_path).to_s
    end

    def slo_url
      @slo_url ||= URI.join(host, slo_path).to_s
    end

    def metadata_url
      @metadata_url ||= URI.join(host, metadata_path).to_s
    end

    def private_key
      @private_key ||= File.read(private_key_file_path)
    end

    def certificate
      @certificate ||= File.read(certificate_file_path)
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
