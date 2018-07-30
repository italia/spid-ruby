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
        if @sso.valid_request?
          @sso.response
        else
          app.call(env)
        end
      end

      class LoginEnv # :nodoc:
        attr_reader :env, :request

        def initialize(env)
          @env = env
          @request = ::Rack::Request.new(env)
        end

        def response
          [
            301,
            { "Location" => sso_url },
            []
          ]
        end

        def sso_url
          Spid::Sso::Request.new(
            idp_name: idp_name
          ).to_saml
        end

        def valid_request?
          valid_path? &&
            !idp_name.nil?
        end

        def valid_path?
          request.path == Spid.configuration.start_sso_path
        end

        def idp_name
          request.params["idp_name"]
        end
      end
    end
  end
end
