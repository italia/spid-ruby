# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Receiving a SSO assertion" do
  let(:app) do
    Rack::Builder.new do
      use Spid::Rack::Sso
      run ->(_env) { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
    end
  end

  let(:request) { Rack::MockRequest.new(app) }

  let(:hostname) { "https://service.provider" }
  let(:acs_path) { "/spid/sso" }

  let(:metadata_dir_path) do
    generate_fixture_path("config/idp_metadata")
  end

  before do
    Spid.configure do |config|
      config.idp_metadata_dir_path = metadata_dir_path
      config.hostname = hostname
      config.acs_path = acs_path
      config.default_relay_state_path = "/default/relay/state/path"
    end
  end

  after do
    Spid.reset_configuration!
  end

  describe "POST /spid/sso" do
    let(:path) { acs_path.to_s }
    let(:saml_response) do
      File.read(
        generate_fixture_path("sso-response.base64")
      )
    end

    let(:rack_session) { {} }

    let(:response) do
      request.post(
        path,
        params: params,
        "rack.session" => rack_session
      )
    end

    let(:params) do
      { SAMLResponse: saml_response, RelayState: "/path/to/return" }
    end

    let(:expected_session) do
      a_hash_including(
        "session_index" => "_be9967abd904ddcae3c0eb4189adbe3f71e327cf93",
        "attributes" => a_hash_including(
          "family_name" => ["Rossi"],
          "spid_code" => ["ABCDEFGHILMNOPQ"]
        )
      )
    end

    before { response }

    it "responds with 302" do
      expect(response.status).to eq 302
    end

    context "when RelayState is provided by IdP" do
      it "redirects to path provided by RelayState" do
        expect(response.location).to eq "/path/to/return"
      end
    end

    context "when RelaySrtate is not provided by IdP" do
      let(:params) do
        { SAMLResponse: saml_response }
      end

      it "redirects to default relay state path" do
        expect(response.location).to eq "/default/relay/state/path"
      end
    end

    it "sets the session with spid data" do
      spid_data = rack_session["spid"]
      expect(spid_data).to match expected_session
    end
  end
end
