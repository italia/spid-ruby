# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Using the Spid::Rack::Logout middleware" do
  let(:app) do
    Rack::Builder.new do
      use Spid::Rack::Logout
      run ->(_env) { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
    end
  end

  let(:session) do
    {
      "spid" => {
        "session_index" => "a-session-index"
      }
    }
  end

  let(:env) do
    {
      "rack.session" => session,
      params: params
    }
  end

  let(:request) { Rack::MockRequest.new(app) }

  let(:hostname) { "https://service.provider" }
  let(:slo_path) { "/spid/slo" }

  let(:metadata_dir_path) do
    generate_fixture_path("config/idp_metadata")
  end

  before do
    Spid.configure do |config|
      config.idp_metadata_dir_path = metadata_dir_path
      config.hostname = hostname
      config.start_slo_path = slo_path
    end
  end

  after do
    Spid.reset_configuration!
  end

  describe "GET start_slo_path" do
    let(:path) { slo_path.to_s }

    let(:params) { {} }

    let(:response) do
      request.get(path, env)
    end

    context "with an idp-name" do
      let(:params) do
        {
          idp_name: "identity-provider"
        }
      end

      it "responds with a redirect" do
        expect(response.status).to eq 301
      end

      it "redirects to the slo path of the identity provider" do
        expect(response.location).
          to match %r{https://identity.provider/slo\?SAMLRequest}
      end
    end

    context "without an idp-name" do
      let(:response) do
        request.get(
          path,
          "rack.session" => {
            "spid" => {
              "session_index" => "a-session-index"
            }
          }
        )
      end

      it "returns the app response" do
        expect(response.status).to eq 200
      end

      it "returns the app body" do
        expect(response.body).to eq "OK"
      end
    end
  end

  xdescribe "GET another path"
end
