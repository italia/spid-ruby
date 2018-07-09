# frozen_string_literal: true

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
  end
end
