# frozen_string_literal: true

require "onelogin/ruby-saml/settings"

module Spid
  module Slo
    class Settings < ::OneLogin::RubySaml::Settings # :nodoc:
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

        super(slo_settings)
      end

      def slo_settings
        [
          service_provider_configuration.slo_attributes,
          identity_provider_configuration.slo_attributes,
          slo_attributes
        ].inject(:merge)
      end

      def slo_attributes
        {
          name_identifier_value: generated_name_identifier_value,
          name_identifier_format: name_identifier_format_value,
          sessionindex: session_index
        }
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
end
