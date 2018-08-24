# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Using the Spid::Rack::Metadata middleware" do
  let(:app) do
    Rack::Builder.new do
      use Spid::Rack::Metadata
      run ->(_env) { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
    end
  end

  let(:request) { Rack::MockRequest.new(app) }

  let(:hostname) { "https://service.provider" }
  let(:metadata_path) { "/spid/metadata" }

  let(:certificate) do
    File.read(generate_fixture_path("certificate.pem"))
  end

  let(:metadata_dir_path) do
    generate_fixture_path("config/idp_metadata")
  end

  let(:attribute_services) do
    [
      { name: "Service 1", fields: [:email] }
    ]
  end

  before do
    Spid.configure do |config|
      config.idp_metadata_dir_path = metadata_dir_path
      config.certificate = certificate
      config.hostname = hostname
      config.metadata_path = metadata_path
      config.attribute_services = attribute_services
    end
  end

  after do
    Spid.reset_configuration!
  end

  describe "GET metadata_path" do
    let(:path) { metadata_path.to_s }

    context "with an idp-name" do
      let(:response) do
        request.get(path)
      end

      it "responds with 200" do
        expect(response).to be_ok
      end

      it "doens't return application body" do
        expect(response.body).not_to eq "OK"
      end

      it "set the 'Content-Type' header with 'application/xml'" do
        content_type_header = response.headers["Content-Type"]

        expect(content_type_header).to eq "application/xml"
      end
    end
  end
end
