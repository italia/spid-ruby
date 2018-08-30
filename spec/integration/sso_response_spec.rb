# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Validation of Spid::Sso::Response" do
  subject(:sso_response) do
    Spid::Sso::Response.new(body: spid_response)
  end

  let(:spid_response) do
    File.read(generate_fixture_path("sso-response.base64"))
  end

  let(:idp_metadata_dir_path) { generate_fixture_path("config/idp_metadata") }
  let(:private_key_path) { generate_fixture_path("private-key.pem") }
  let(:certificate_path) { generate_fixture_path("certificate.pem") }

  let(:host) { "https://service.provider" }
  let(:idp_issuer) { "https://identity.provider" }

  let(:acs_path) { "/spid/sso" }

  before do
    Spid.configure do |config|
      config.hostname = "https://service.provider"
      config.idp_metadata_dir_path = idp_metadata_dir_path
      config.private_key = File.read(private_key_path)
      config.certificate = File.read(certificate_path)
      config.acs_path = acs_path
      config.attribute_services = [
        { name: "Service 1", fields: [:email] }
      ]
    end
  end

  after do
    Spid.reset_configuration!
  end

  it "requires a body" do
    expect(sso_response.body).to eq spid_response
  end

  context "when response conforms to the request" do
    it { is_expected.to be_valid }
  end

  context "when response isn't conform to the request" do
    let(:acs_path) { "/spid/another/sso" }

    it { is_expected.not_to be_valid }
  end

  describe "#issuer" do
    it "returns the identity provider issuer" do
      expect(sso_response.issuer).to eq idp_issuer
    end
  end

  describe "#attributes" do
    it "returns attributes provided by identity provider" do
      expect(sso_response.attributes).
        to match a_hash_including(
          "family_name" => "Rossi",
          "spid_code" => "ABCDEFGHILMNOPQ"
        )
    end
  end

  describe "#session_index" do
    it "returns session index of current session" do
      expect(sso_response.session_index).
        to eq "_be9967abd904ddcae3c0eb4189adbe3f71e327cf93"
    end
  end
end
