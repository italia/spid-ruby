# frozen_string_literal: true

module Spid
  class Rack
    class Login # :nodoc:
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        @sso = LoginEnv.new(env)

        return @sso.response if @sso.valid_request?

        app.call(env)
      end

      class LoginEnv # :nodoc:
        attr_reader :env, :request

        def initialize(env)
          @env = env
          @request = ::Rack::Request.new(env)
        end

        def session
          request.session["spid"]
        end

        def response
          session["sso_request_uuid"] = responser.uuid
          [
            302,
            { "Location" => sso_url },
            []
          ]
        end

        def sso_url
          responser.url
        end

        def responser
          @responser ||=
            begin
              Spid::Sso::Request.new(
                idp_name: idp_name,
                relay_state: relay_state,
                attribute_index: attribute_consuming_service_index
              )
            end
        end

        def valid_request?
          valid_path? &&
            !idp_name.nil?
        end

        def valid_path?
          request.path == Spid.configuration.start_sso_path
        end

        def relay_state
          request.params["relay_state"]
        end

        def idp_name
          request.params["idp_name"]
        end

        def attribute_consuming_service_index
          request.params["attribute_index"] || "0"
        end
      end
    end
  end
end
