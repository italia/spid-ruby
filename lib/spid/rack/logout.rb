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
        if @slo.valid_request?
          @slo.response
        else
          app.call(env)
        end
      end

      class LogoutEnv # :nodoc:
        attr_reader :env, :request

        def initialize(env)
          @env = env
          @request = ::Rack::Request.new(env)
        end

        def response
          [
            302,
            { "Location" => slo_url },
            []
          ]
        end

        def slo_url
          Spid::Slo::Request.new(
            idp_name: idp_name,
            relay_state: relay_state,
            session_index: spid_session["session-index"]
          ).to_saml
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
