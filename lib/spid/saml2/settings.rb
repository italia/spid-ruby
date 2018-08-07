# frozen_string_literal: true

module Spid
  module Saml2
    class Settings # :nodoc:
      attr_reader :identity_provider
      attr_reader :service_provider
      attr_reader :authn_context

      def initialize(identity_provider:, service_provider:, authn_context: nil)
        @authn_context = authn_context || Spid::L1
        unless AUTHN_CONTEXTS.include?(@authn_context)
          raise Spid::UnknownAuthnContextError,
                "Provided authn_context '#{@authn_context}' is not valid:" \
                " use one of #{AUTHN_CONTEXTS.join(', ')}"
        end

        @identity_provider = identity_provider
        @service_provider = service_provider
      end

      def idp_entity_id
        identity_provider.entity_id
      end

      def sp_entity_id
        service_provider.host
      end

      def acs_index
        "0"
      end

      def force_authn?
        authn_context > Spid::L1
      end
    end
  end
end
