# frozen_string_literal: true

module Spid
  class Rack
    class Metadata # :nodoc:
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        @metadata = MetadataEnv.new(env)

        return @metadata.response if @metadata.valid_request?

        app.call(env)
      end

      class MetadataEnv # :nodoc:
        attr_reader :env, :request

        def initialize(env)
          @env = env
          @request = ::Rack::Request.new(env)
        end

        def metadata
          @metadata ||= ::Spid::Metadata.new
        end

        def response
          [
            200,
            { "Content-Type" => "application/xml" },
            metadata.to_xml
          ]
        end

        def valid_request?
          request.path == Spid.configuration.metadata_path
        end
      end
    end
  end
end
