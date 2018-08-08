# frozen_string_literal: true

require "base64"
require "zlib"
require "cgi"
require "spid/saml2/utils/query_params_signer"

module Spid
  module Saml2
    module Utils # :nodoc:
      def encode(message)
        Base64.encode64(message)
      end

      def deflate(message)
        Zlib::Deflate.deflate(message, 9)[2..-5]
      end

      def deflate_and_encode(message)
        encode(deflate(message)).delete("\n")
      end

      def escaped_params(params)
        params.each_with_object({}) do |(key, value), acc|
          acc[key] = CGI.escape(value)
        end
      end

      def query_param(key, value)
        "#{key}=#{value}"
      end

      def query_params(params)
        params.map do |key, value|
          query_param(key, value)
        end
      end

      def query_string(params)
        query_params(params).join("&")
      end

      def escaped_query_string(params)
        query_string(escaped_params(params))
      end
    end
  end
end
