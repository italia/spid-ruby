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
        env["rack.session"].delete("spid") if @slo.valid_request?
        app.call(env)
      end

      class SloEnv # :nodoc:
        attr_reader :env
        attr_reader :request

        def initialize(env)
          @env = env
          @request = ::Rack::Request.new(env)
        end

        def valid_request?
          request.path == Spid.configuration.slo_path
        end
      end
    end
  end
end
