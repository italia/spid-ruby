# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Using the Spid::Rack::Login middleware" do
  let(:app) do
    Rack::Builder.new do
      use Spid::Rack::Login
      run ->(_env) { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
    end
  end

  let(:request) { Rack::MockRequest.new(app) }

  let(:hostname) { "https://service.provider" }
  let(:sso_path) { "/spid/sso" }

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
      config.start_sso_path = sso_path
      config.private_key = private_key
      config.certificate = certificate
      config.default_relay_state_path = default_relay_state_path
    end
  end

  after do
    Spid.reset_configuration!
  end

  describe "GET start_sso_path" do
    let(:path) { sso_path.to_s }

    context "with an idp-name" do
      let(:response) do
        request.get(path, params: { idp_name: "identity-provider" })
      end

      it "responds with a redirect" do
        expect(response).to be_moved_permanently
      end

      describe "Location header url" do
        let(:location) { response.location }
        let(:uri) { URI.parse(location) }

        it "redirects to the sso path of the identity provider" do
          host = "#{uri.scheme}://#{uri.host}"
          expect(host).to eq "https://identity.provider"
        end

        describe "params" do
          let(:params) { CGI.parse(uri.query) }

          [
            "SAMLRequest",
            "SigAlg",
            "RelayState",
            "Signature"
          ].each do |param|
            it "contains #{param}" do
              expect(params.keys).to include param
            end
          end
        end
      end
    end

    context "without an idp-name" do
      let(:response) { request.get(path, {}) }

      it "returns the app response" do
        expect(response).to be_ok
      end

      it "returns the app body" do
        expect(response.body).to eq "OK"
      end
    end
  end

  xdescribe "GET another path"
end
