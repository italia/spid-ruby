# frozen_string_literal: true

require "uri"

module Spid
  class ServiceProviderConfiguration # :nodoc:
    attr_reader :host,
                :sso_path,
                :slo_path,
                :metadata_path,
                :private_key_file_path,
                :certificate_file_path

    # rubocop:disable Metrics/ParameterLists
    def initialize(
          host:,
          sso_path:,
          slo_path:,
          metadata_path:,
          private_key_file_path:,
          certificate_file_path:
        )
      @host = host
      @sso_path = sso_path
      @slo_path = slo_path
      @metadata_path = metadata_path
      @private_key_file_path = private_key_file_path
      @certificate_file_path = certificate_file_path
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
  end
end
