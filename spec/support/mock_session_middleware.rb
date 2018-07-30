# frozen_string_literal: true

class MockSessionMiddleware
  attr_reader :app, :initial_session

  def initialize(app, initial_session = {})
    @app = app
    @initial_session = initial_session
  end

  def call(env)
    env["rack.session"] = initial_session
    app.call(env)
  end
end
