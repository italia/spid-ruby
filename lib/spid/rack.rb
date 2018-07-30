# frozen_string_literal: true

require "rack/builder"
require "spid/rack/login"
require "spid/rack/logout"

module Spid
  class Rack # :nodoc:
    attr_reader :app

    def initialize(app)
      @app = ::Rack::Builder.new do
        use Spid::Rack::Login
        use Spid::Rack::Logout
        run app
      end
    end

    def call(env)
      app.call(env)
    end
  end
end
