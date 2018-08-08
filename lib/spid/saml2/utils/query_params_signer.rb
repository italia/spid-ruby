# frozen_string_literal: true

require "base64"

module Spid
  module Saml2
    module Utils
      class QueryParamsSigner # :nodoc:
        attr_reader :query_params
        attr_reader :private_key
        attr_reader :signature_method

        def initialize(query_params:, private_key:, signature_method:)
          @query_params = query_params
          @query_params["SigAlg"] = signature_method
          @private_key = OpenSSL::PKey::RSA.new(private_key)
          @signature_method = signature_method
        end

        def signature_algorithm
          @signature_algorithm ||=
            case signature_method
            when Spid::RSA_SHA256 then OpenSSL::Digest::SHA256.new
            when Spid::RSA_SHA384 then OpenSSL::Digest::SHA384.new
            when Spid::RSA_SHA512 then OpenSSL::Digest::SHA512.new
            end
        end

        def signature
          @signature ||=
            begin
              Base64.encode64(
                private_key.sign(signature_algorithm, escaped_query_string)
              )
            end
        end

        def escaped_query_string
          @escaped_query_string ||=
            begin
              query_params.map do |param_name, param_value|
                "#{param_name}=#{CGI.escape(param_value)}"
              end.join("&")
            end
        end
      end
    end
  end
end
