# frozen_string_literal: true

module Spid
  class Rack
    class Session # :nodoc:
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        request = ::Rack::Request.new(env)
        request.session["spid"] ||= {}
        app.call(env)
      end
    end
  end
end
