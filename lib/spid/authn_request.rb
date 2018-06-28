# frozen_string_literal: true

module Spid
  class AuthnRequest # :nodoc:
    def initialize(idp_sso_target_url:)
    end

    def to_xml
      "<samlp:AuthnRequest />"
    end
  end
end
