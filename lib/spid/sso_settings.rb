# frozen_string_literal: true

module Spid
  class SsoSettings < ::OneLogin::RubySaml::Settings # :nodoc:
    attr_reader :service_provider_configuration,
                :identity_provider_configuration

    def initialize(
          service_provider_configuration:,
          identity_provider_configuration:
        )
      @service_provider_configuration = service_provider_configuration
      @identity_provider_configuration = identity_provider_configuration
    end
  end
end
