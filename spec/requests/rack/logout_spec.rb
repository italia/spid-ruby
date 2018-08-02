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

  let(:certificate) do
    File.read(generate_fixture_path("certificate.pem"))
  end

  let(:private_key) do
    File.read(generate_fixture_path("private-key.pem"))
  end

  let(:default_relay_state_path) { "/path/to/return" }

  before do
    Spid.configure do |config|
      config.idp_metadata_dir_path = metadata_dir_path
      config.hostname = hostname
      config.start_slo_path = slo_path
      config.private_key = private_key
      config.certificate = certificate
      config.default_relay_state_path = default_relay_state_path
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
        expect(response.status).to eq 302
      end

      describe "Location header url" do
        let(:location) { response.location }
        let(:uri) { URI.parse(location) }

        it "redirects to the slo path of the identity provider" do
          host = "#{uri.scheme}://#{uri.host}#{uri.path}"
          expect(host).to eq "https://identity.provider/slo"
        end

        describe "params" do
          let(:url_params) { CGI.parse(uri.query) }

          [
            "SAMLRequest",
            "SigAlg",
            "RelayState",
            "Signature"
          ].each do |param|
            it "contains #{param}" do
              expect(url_params.keys).to include param
            end
          end
        end
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
