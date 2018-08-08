# frozen_string_literal: true

require "base64"

module Spid
  module Saml2
    module Utils
      class QueryParamsSigner # :nodoc:
        include Spid::Saml2::Utils

        attr_reader :saml_message
        attr_reader :private_key
        attr_reader :signature_method
        attr_reader :relay_state

        def initialize(
              saml_message:,
              private_key:,
              signature_method:,
              relay_state: nil
            )
          @saml_message = saml_message.delete("\n")
          @private_key = OpenSSL::PKey::RSA.new(private_key)
          @signature_method = signature_method
          @relay_state = relay_state
        end

        def signature_algorithm
          @signature_algorithm ||= Spid::SIGNATURE_ALGORITHMS[signature_method]
        end

        def signature
          @signature ||=
            begin
              encode(raw_signature)
            end
        end

        def signed_query_params
          params_for_signature.merge(
            "Signature" => signature
          )
        end

        def raw_signature
          @raw_signature ||=
            begin
              private_key.sign(
                signature_algorithm,
                escaped_query_string(params_for_signature)
              )
            end
        end

        def params_for_signature
          @params_for_signature ||=
            begin
              params = {
                "SAMLRequest" => deflate_and_encode(saml_message),
                "RelayState" => relay_state,
                "SigAlg" => signature_method
              }
              params.delete("RelayState") if params["RelayState"].nil?
              params
            end
        end
      end
    end
  end
end
