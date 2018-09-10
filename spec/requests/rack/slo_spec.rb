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
      config.default_relay_state_path = "/default/relay/state/path"
      config.attribute_services = [
        { name: "Service 1", fields: [:email] }
      ]
    end
  end

  after do
    Spid.reset_configuration!
  end

  describe "GET /spid/slo" do
    let(:path) { slo_path.to_s }

    let(:saml_response) do
      File.read(generate_fixture_path("slo-response/encoded.base64"))
    end

    let(:response) do
      request.get(
        path,
        params: params,
        "rack.session" => rack_session
      )
    end

    let(:rack_session) do
      {
        "spid" => spid_session
      }
    end

    context "when request is a sp-initiated response from identity provider" do
      let(:params) do
        { SAMLResponse: saml_response, RelayState: "/path/to/return" }
      end

      let(:spid_session) do
        {
          "slo_request_uuid" => request_uuid
        }
      end

      let(:request_uuid) { "_21df91a89767879fc0f7df6a1490c6000c81644d" }

      it "responds with 302" do
        expect(response.status).to eq 302
      end

      it "remove all spid data from the session" do
        response

        expect(rack_session["spid"]).to eq({})
      end

      context "when RelayState is provided by IdP" do
        it "redirects to path provided by RelayState" do
          expect(response.location).to eq "/path/to/return"
        end
      end

      context "when RelayState is not provided by IdP" do
        let(:params) do
          { SAMLResponse: saml_response }
        end

        it "redirects to default relay state path" do
          expect(response.location).to eq "/default/relay/state/path"
        end
      end

      context "when there are errors on response" do
        let(:request_uuid) { "invalid-request-uuid" }

        let(:expected_session) do
          a_hash_including(
            "slo_request_uuid" => request_uuid,
            "errors" => {
              "request_uuid_mismatch" =>
              "Request uuid not belongs to current session"
            }
          )
        end

        it "sets error message in spid session" do
          response

          expect(rack_session["spid"]).to match expected_session
        end
      end
    end

    context "when request is a idp-initiated response from identity provider" do
      let(:params) do
        { SAMLRequest: saml_request }
      end

      let(:spid_session) { {} }

      let(:expected_body) do
        %r{<samlp:LogoutResponse.*?</samlp:LogoutResponse>}
      end

      let(:saml_request) do
        File.read(generate_fixture_path("slo-request/encoded.base64"))
      end

      it "responds with 200" do
        expect(response.status).to eq 200
      end

      it "returns the saml logout response" do
        expect(response.body).to match expected_body
      end
    end
  end
end
