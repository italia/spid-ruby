# frozen_string_literal: true

module Spid
  class Rack
    class Logout # :nodoc:
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        @slo = LogoutEnv.new(env)

        return @slo.response if @slo.valid_request?

        app.call(env)
      end

      class LogoutEnv # :nodoc:
        attr_reader :env, :request

        def initialize(env)
          @env = env
          @request = ::Rack::Request.new(env)
        end

        def response
          session["slo_request_uuid"] = slo_request.uuid
          [
            302,
            { "Location" => slo_url },
            []
          ]
        end

        def session
          request.session["spid"]
        end

        def slo_url
          slo_request.url
        end

        def slo_request
          @slo_request ||=
            begin
              Spid::Slo::Request.new(
                idp_name: idp_name,
                relay_state: relay_state,
                session_index: spid_session["session_index"]
              )
            end
        end

        def valid_request?
          valid_path? &&
            !idp_name.nil? &&
            !spid_session.nil?
        end

        def valid_path?
          request.path == Spid.configuration.start_slo_path
        end

        def spid_session
          request.session["spid"]
        end

        def relay_state
          request.params["relay_state"]
        end

        def idp_name
          request.params["idp_name"]
        end
      end
    end
  end
end
