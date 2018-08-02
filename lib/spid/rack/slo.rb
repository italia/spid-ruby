# frozen_string_literal: true

module Spid
  class Rack
    class Slo # :nodoc:
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        @slo = SloEnv.new(env)
        if @slo.valid_request?
          @slo.response
        else
          app.call(env)
        end
      end

      class SloEnv # :nodoc:
        attr_reader :env
        attr_reader :request

        def initialize(env)
          @env = env
          @request = ::Rack::Request.new(env)
        end

        def clear_session
          request.session["spid"] = {}
        end

        def response
          clear_session
          [
            302,
            { "Location" => relay_state },
            []
          ]
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
            Spid.configuration.slo_binding == Spid::BINDINGS_HTTP_REDIRECT
        end

        def valid_post?
          request.post? &&
            Spid.configuration.slo_binding == Spid::BINDINGS_HTTP_POST
        end

        def valid_http_verb?
          valid_post? || valid_get?
        end

        def valid_path?
          request.path == Spid.configuration.slo_path
        end

        def valid_request?
          valid_path? && valid_http_verb?
        end
      end
    end
  end
end
