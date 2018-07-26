# frozen_string_literal: true

module Spid
  class Configuration # :nodoc:
    attr_accessor :idp_metadata_dir_path
    attr_accessor :hostname
    attr_accessor :metadata_path
    attr_accessor :start_sso_path
    attr_accessor :start_slo_path
    attr_accessor :acs_path
    attr_accessor :slo_path
    attr_accessor :digest_method
    attr_accessor :signature_method
    attr_accessor :private_key
    attr_accessor :certificate
    attr_accessor :attribute_service_name

    # rubocop:disable Metrics/MethodLength
    def initialize
      @idp_metadata_dir_path  = "idp_metadata"
      @metadata_path          = "/spid/metadata"
      @start_sso_path         = "/spid/login"
      @start_slo_path         = "/spid/logout"
      @acs_path               = "/spid/sso"
      @slo_path               = "/spid/slo"
      @digest_method          = Spid::SHA256
      @signature_method       = Spid::RSA_SHA256
      @attribute_service_name = attribute_service_name
      @hostname               = nil
      @private_key            = nil
      @certificate            = nil
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def service_provider
      @service_provider ||=
        begin
          Spid::ServiceProvider.new(
            host: hostname,
            acs_path: acs_path,
            slo_path: slo_path,
            metadata_path: metadata_path,
            private_key: private_key,
            certificate: certificate,
            digest_method: digest_method,
            signature_method: signature_method,
            attribute_service_name: attribute_service_name
          )
        end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
