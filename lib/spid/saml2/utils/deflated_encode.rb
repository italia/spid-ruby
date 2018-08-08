# frozen_string_literal: true

require "zlib"
require "base64"

module Spid
  module Saml2
    module Utils
      class DeflatedEncode # :nodoc:
        attr_reader :message

        def initialize(message:)
          @message = message
        end

        def deflated
          @deflated ||= Zlib::Deflate.deflate(message, 9)[2..-5]
        end

        def encode
          @encode ||= Base64.encode64(deflated).delete("\n")
        end
      end
    end
  end
end
