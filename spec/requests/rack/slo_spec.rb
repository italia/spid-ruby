# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Receiving a SLO assertion" do
  let(:app) do
    Rack::Builder.new do
      use Spid::Rack::Slo
      run ->(_env) { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
    end
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
      config.slo_path = slo_path
    end
  end

  after do
    Spid.reset_configuration!
  end

  describe "POST /spid/slo" do
    let(:path) { slo_path.to_s }

    let(:saml_response) do
      File.read(generate_fixture_path("slo-response.base64"))
    end

    let(:rack_session) do
      {
        "spid" => {}
      }
    end

    let(:response) do
      request.post(
        path,
        params: { SAMLResponse: saml_response, RelayState: "/path/to/return" },
        "rack.session" => rack_session
      )
    end

    before { response }

    it "responds with 302" do
      expect(response.status).to eq 302
    end

    it "redirects to path provided by RelayState" do
      expect(response.location).to eq "/path/to/return"
    end

    it "remove all spid data from the session" do
      spid_data = rack_session["spid"]
      expect(spid_data).to eq({})
    end
  end
end
