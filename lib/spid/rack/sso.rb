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

        if @sso.valid_path?
          response = @sso.sso_response
          env["rack.session"]["spid"] = {
            "attributes" => response.attributes,
            "session_index" => response.session_index
          }
        end
        app.call(env)
      end

      class SsoEnv # :nodoc:
        attr_reader :env
        attr_reader :request

        def initialize(env)
          @env = env
          @request = ::Rack::Request.new(env)
        end

        def saml_response
          request.params["SAMLResponse"]
        end

        def valid_path?
          request.path == Spid.configuration.acs_path
        end

        def sso_response
          ::Spid::Sso::Response.new(body: saml_response)
        end
      end
    end
  end
end