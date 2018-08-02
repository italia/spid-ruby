# frozen_string_literal: true

module Spid
  class Rack
    class Sso # :nodoc:
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        @sso = SsoEnv.new(env)

        if @sso.valid_request?
          @sso.response
        else
          app.call(env)
        end
      end

      class SsoEnv # :nodoc:
        attr_reader :env
        attr_reader :request

        def initialize(env)
          @env = env
          @request = ::Rack::Request.new(env)
        end

        def store_session
          request.session["spid"] = {
            "attributes" => sso_response.attributes,
            "session_index" => sso_response.session_index
          }
        end

        def response
          store_session
          [
            302,
            { "Location" => relay_state },
            []
          ]
        end

        def saml_response
          request.params["SAMLResponse"]
        end

        def relay_state
          request.params["RelayState"]
        end

        def valid_request?
          request.path == Spid.configuration.acs_path
        end

        def sso_response
          ::Spid::Sso::Response.new(body: saml_response)
        end
      end
    end
  end
end
