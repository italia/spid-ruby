# frozen_string_literal: true

module Spid
  class AuthnRequest # :nodoc:
    def to_xml
      "<samlp:AuthnRequest />"
    end
  end
end
