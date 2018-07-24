# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Sso::Response do
  subject(:sso_response) do
    described_class.new(body: spid_response, sso_settings: sso_settings)
  end

  let(:spid_response) do
    File.read(generate_fixture_path("sso-response.base64"))
  end
  let(:idp_metadata) do
    File.read(generate_fixture_path("identity-provider-metadata.xml"))
  end

  let(:sso_settings) do
    Spid::Sso::Settings.new(
      service_provider_configuration: service_provider_configuration,
      identity_provider_configuration: identity_provider_configuration
    )
  end
  let(:identity_provider_configuration) do
    instance_double(
      "Spid::IdentityProviderConfiguration",
      sso_attributes: {
        idp_sso_target_url: "https://identity.provider/sso",
        idp_cert_fingerprint: cert_fingerprint
      }
    )
  end

  let(:service_provider_configuration) do
    instance_double(
      "Spid::ServiceProviderConfiguration",
      sso_attributes: {
        assertion_consumer_service_url: "https://service.provider/sso",
        issuer: host,
        private_key: File.read(generate_fixture_path("private-key.pem")),
        certificate: File.read(generate_fixture_path("certificate.pem")),
        security: {
          authn_requests_signed: true,
          embed_sign: true,
          digest_method: Spid::SHA256,
          signature_method: Spid::RSA_SHA256
        }
      }
    )
  end
  let(:cert_fingerprint) do
    "C6:82:11:E5:44:22:53:58:05:B2:3F:2D:24:52:8B:17:95:C3:62:89"
  end
  let(:host) { "https://service.provider" }
  let(:idp_issuer) { "https://identity.provider" }

  it { is_expected.to be_a described_class }

  it "requires a body" do
    expect(sso_response.body).to eq spid_response
  end

  it "requires a saml_settings configuration" do
    expect(sso_response.sso_settings).to eq sso_settings
  end

  context "when response conforms to the request" do
    it { is_expected.to be_valid }
  end

  context "when response isn't conform to the request" do
    let(:host) { "https://another-service.provider" }

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
          family_name: ["Rossi"],
          spid_code: ["ABCDEFGHILMNOPQ"]
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
