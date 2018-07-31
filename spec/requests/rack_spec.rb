# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Using the middleware" do
  let(:app) do
    Rack::Builder.new do
      use Spid::Rack
      run ->(_env) { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
    end
  end

  let(:request) { Rack::MockRequest.new(app) }

  describe "GET /" do
    let(:response) { request.get("/") }

    it "return the main application body" do
      expect(response.body).to eq "OK"
    end

    it "returns the application status response" do
      expect(response.status).to eq 200
    end
  end
end
