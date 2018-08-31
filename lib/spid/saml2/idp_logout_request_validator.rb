# frozen_string_literal: true

module Spid
  module Saml2
    class IdpLogoutRequestValidator # :nodoc:
      attr_reader :request

      def initialize(request:)
        @request = request
      end

      def call
        true
      end
    end
  end
end
