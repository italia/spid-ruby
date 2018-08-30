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

        return @sso.response if @sso.valid_request?

        app.call(env)
      end

      class SsoEnv # :nodoc:
        attr_reader :env
        attr_reader :request

        def initialize(env)
          @env = env
          @request = ::Rack::Request.new(env)
        end

        def session
          request.session["spid"]
        end

        def store_session_success
          session["attributes"] = sso_response.attributes
          session["session_index"] = sso_response.session_index
        end

        def store_session_failure
          session["errors"] = sso_response.errors
        end

        def response
          if valid_response?
            store_session_success
          else
            store_session_failure
          end
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
          if !request.params["RelayState"].nil? &&
             request.params["RelayState"] != ""
            request.params["RelayState"]
          else
            Spid.configuration.default_relay_state_path
          end
        end

        def valid_get?
          request.get? &&
            Spid.configuration.acs_binding == Spid::BINDINGS_HTTP_REDIRECT
        end

        def valid_post?
          request.post? &&
            Spid.configuration.acs_binding == Spid::BINDINGS_HTTP_POST
        end

        def valid_http_verb?
          valid_get? || valid_post?
        end

        def valid_path?
          request.path == Spid.configuration.acs_path
        end

        def valid_response?
          sso_response.valid?
        end

        def valid_request?
          valid_path? && valid_http_verb?
        end

        def sso_response
          @sso_response ||= ::Spid::Sso::Response.new(body: saml_response)
        end
      end
    end
  end
end
