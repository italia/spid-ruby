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
          session["slo_request_uuid"] = responser.uuid
          session["relay_state"] = {
            relay_state_id => relay_state
          }
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
          responser.url
        end

        def responser
          @responser ||=
            begin
              Spid::Slo::Request.new(
                idp_name: idp_name,
                relay_state: relay_state_id,
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
          request.path == Spid.configuration.logout_path
        end

        def spid_session
          request.session["spid"]
        end

        def relay_state
          request.params["relay_state"] ||
            Spid.configuration.default_relay_state_path
        end

        def relay_state_id
          digest = Digest::MD5.hexdigest(relay_state)
          "_#{digest}"
        end

        def idp_name
          request.params["idp_name"]
        end
      end
    end
  end
end
