# frozen_string_literal: true

require "base64"
require "zlib"
require "spid/saml2/utils/query_params_signer"

module Spid
  module Saml2
    class Utils # :nodoc:
      class << self
        def encode(message)
          Base64.encode64(message)
        end

        def decode(message)
          Base64.decode64(message)
        end

        def deflate(message)
          Zlib::Deflate.deflate(message, 9)[2..-5]
        end

        def inflate(message)
          Zlib::Inflate.new(-Zlib::MAX_WBITS).inflate(message)
        end

        def deflate_and_encode(message)
          encode(deflated(message))
        end

        def decode_and_inflate(message)
          inflate(decode(message))
        end
      end
    end
  end
end
