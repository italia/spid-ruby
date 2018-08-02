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
          request.params["RelayState"]
        end

        def valid_request?
          request.path == Spid.configuration.slo_path
        end
      end
    end
  end
end
