# frozen_string_literal: true

module Spid
  class SloRequest # :nodoc:
    attr_reader :slo_settings

    def initialize(slo_settings:)
      @slo_settings = slo_settings
    end

    def to_saml
      logout_request.create(slo_settings)
    end

    private

    def logout_request
      LogoutRequest.new
    end
  end
end
