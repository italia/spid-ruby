# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Slo::Response do
  subject(:slo_response) do
    described_class.new(body: spid_response, slo_settings: slo_settings)
  end

  let(:spid_response) do
    File.read(generate_fixture_path("slo-response.base64"))
  end

  let(:slo_settings) do
    Spid::Slo::Settings.new(
      service_provider_configuration: service_provider_configuration,
      identity_provider_configuration: identity_provider_configuration,
      session_index: session_index
    )
  end

  let(:identity_provider_configuration) do
    instance_double(
      "Spid::IdentityProviderConfiguration",
      entity_id: "https://identity.provider",
      slo_target_url: "https://identity.provider/slo",
      cert_fingerprint: cert_fingerprint
    )
  end
  let(:service_provider_configuration) do
    instance_double(
      "Spid::ServiceProviderConfiguration",
      host: host,
      private_key: File.read(generate_fixture_path("private-key.pem")),
      certificate: File.read(generate_fixture_path("certificate.pem")),
      digest_method: Spid::SHA256,
      signature_method: Spid::RSA_SHA256
    )
  end
  let(:cert_fingerprint) do
    "C6:82:11:E5:44:22:53:58:05:B2:3F:2D:24:52:8B:17:95:C3:62:89"
  end

  let(:host) { "https://service.provider" }
  let(:session_index) { "a-session-index" }

  let(:idp_metadata) do
    File.read(generate_fixture_path("identity-provider-metadata.xml"))
  end

  it { is_expected.to be_a described_class }

  it "requires a body" do
    expect(slo_response.body).to eq spid_response
  end

  it "requires a saml_settings configuration" do
    expect(slo_response.slo_settings).to eq slo_settings
  end

  context "when response conforms to the request" do
    it { is_expected.to be_valid }
  end

  context "when response isn't conform to the request" do
    before do
      allow(slo_settings).
        to receive(:idp_entity_id).
        and_return("https://another-identity.provider")
    end

    it { is_expected.not_to be_valid }
  end
end
