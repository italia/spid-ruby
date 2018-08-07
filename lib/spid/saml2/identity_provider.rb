# frozen_string_literal: true

require "onelogin/ruby-saml/idp_metadata_parser"

module Spid
  module Saml2
    class IdentityProvider # :nodoc:
      attr_reader :name
      attr_reader :entity_id
      attr_reader :sso_target_url
      attr_reader :slo_target_url
      attr_reader :cert_fingerprint

      def initialize(
            name:,
            entity_id:,
            sso_target_url:,
            slo_target_url:,
            cert_fingerprint:
          )
        @name = name
        @entity_id = entity_id
        @sso_target_url = sso_target_url
        @slo_target_url = slo_target_url
        @cert_fingerprint = cert_fingerprint
      end

      def sso_attributes
        @sso_attributes ||=
          begin
            {
              idp_sso_target_url: sso_target_url,
              idp_cert_fingerprint: cert_fingerprint
            }
          end
      end

      def slo_attributes
        @slo_attributes ||=
          begin
            {
              idp_slo_target_url: slo_target_url,
              idp_name_qualifier: entity_id,
              idp_cert_fingerprint: cert_fingerprint
            }
          end
      end
    end
  end
end
