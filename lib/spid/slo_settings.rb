# frozen_string_literal: true

require "onelogin/ruby-saml/settings"

module Spid
  class SloSettings < ::OneLogin::RubySaml::Settings # :nodoc:
    attr_reader :service_provider_configuration,
                :identity_provider_configuration,
                :session_index

    def initialize(
          service_provider_configuration:,
          identity_provider_configuration:,
          session_index:
        )
      @service_provider_configuration = service_provider_configuration
      @identity_provider_configuration = identity_provider_configuration
      @session_index = session_index

      super(slo_attributes)
    end

    def slo_attributes
      return @slo_attributes if @slo_attributes.present?
      @slo_attributes = {
        idp_slo_target_url: identity_provider_configuration.slo_target_url,
        issuer: service_provider_configuration.host,
        idp_name_qualifier: identity_provider_configuration.entity_id,
        name_identifier_value: generated_name_identifier_value,
        name_identifier_format: name_identifier_format_value,
        sessionindex: session_index
      }
      @slo_attributes
    end

    private

    def generated_name_identifier_value
      ::OneLogin::RubySaml::Utils.uuid
    end

    def name_identifier_format_value
      "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
    end
  end
end
