require "yaml"

module Spid
  class ServiceProviderManager
    include Singleton

    def service_providers
      @service_providers ||=
        begin
          parse_config_file.map(&:symbolize_keys).map do |sp|
            ServiceProviderConfiguration.new(
              host: sp[:host],
              sso_path: sp[:sso_path],
              slo_path: sp[:slo_path],
              metadata_path: sp[:metadata_path],
              digest_method:
                digest_method_from_size(sp[:digest_method_size]),
              signature_method:
                signature_method_from_size(sp[:signature_method_size]),
              private_key_file_path:
                file_path_from_name(sp[:private_key_name]),

              certificate_file_path:
                file_path_from_name(sp[:certificate_name])
            )
          end
        end
    end

    def self.find_by_host(host)
      instance.service_providers.find do |sp|
        sp.host == host
      end
    end

    private

    def digest_method_from_size(size)
      case size
      when 256 then Spid::SHA256
      when 384 then Spid::SHA384
      when 512 then Spid::SHA512
      else raise UnknownDigestMethodError
      end
    end

    def signature_method_from_size(size)
      case size
      when 256 then Spid::RSA_SHA256
      when 384 then Spid::RSA_SHA384
      when 512 then Spid::RSA_SHA512
      else raise UnknownSignatureMethodError
      end
    end

    def file_path_from_name(filename)
      File.join(
        Spid.configuration.sp_configuration_file_path,
        filename
      )
    end

    def parse_config_file
      YAML.load_file(
        Spid.configuration.sp_configuration_file_path
      )
    end
  end
end
