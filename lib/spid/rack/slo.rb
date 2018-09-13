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

        return @slo.response if @slo.valid_request?

        app.call(env)
      end

      # rubocop:disable Metrics/ClassLength
      class SloEnv # :nodoc:
        attr_reader :env
        attr_reader :request

        def initialize(env)
          @env = env
          @request = ::Rack::Request.new(env)
        end

        def session
          request.session["spid"]
        end

        def clear_session
          request.session["spid"] = {}
        end

        def store_session_failure
          session["errors"] = responser.errors
        end

        def response_sp_initiated
          [
            302,
            { "Location" => @relay_state },
            responser.response
          ]
        end

        def response_idp_initiated
          [
            200,
            {},
            responser.response
          ]
        end

        def validate_session
          valid_response? ? clear_session : store_session_failure
        end

        def response
          @relay_state = relay_state unless idp_initiated?
          validate_session
          return response_idp_initiated if idp_initiated?
          response_sp_initiated
        end

        def relay_state_param
          request.params["RelayState"]
        end

        def request_relay_state
          if !relay_state_param.nil? ||
             relay_state_param != ""
            session["relay_state"][relay_state_param]
          end
        end

        def relay_state
          if request_relay_state.nil?
            return Spid.configuration.default_relay_state_path
          end
          session["relay_state"][relay_state_param]
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

        def valid_response?
          responser.valid?
        end

        def valid_request?
          valid_path? && valid_http_verb?
        end

        def saml_response
          request.params["SAMLResponse"]
        end

        def saml_request
          request.params["SAMLRequest"]
        end

        def idp_initiated?
          !saml_request.nil?
        end

        def responser
          @responser ||=
            begin
              if idp_initiated?
                idp_initiated_slo_request
              else
                sp_initiated_slo_response
              end
            end
        end

        private

        def idp_initiated_slo_request
          ::Spid::Slo::IdpRequest.new(
            body: saml_request,
            session_index: session["session_index"]
          )
        end

        def sp_initiated_slo_response
          ::Spid::Slo::Response.new(
            body: saml_response,
            request_uuid: session["slo_request_uuid"],
            session_index: session["session_index"]
          )
        end
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
