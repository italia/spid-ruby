# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::SsoResponse do
  subject(:sso_response) do
    described_class.new(body: spid_response, sso_settings: saml_settings)
  end

  let(:spid_response) do
    File.read(generate_fixture_path("spid-response-encoded.base64"))
  end
  let(:idp_metadata) do
    File.read(generate_fixture_path("identity-provider-metadata.xml"))
  end
  let(:sso_request) do
    Spid::SsoRequest.new(
      service_provider_configuration: service_provider_configuration,
      identity_provider_configuration: identity_provider_configuration
    )
  end
  let(:identity_provider_configuration) do
    Spid::IdentityProviderConfiguration.new(
      idp_metadata: idp_metadata
    )
  end
  let(:service_provider_configuration) do
    Spid::ServiceProviderConfiguration.new(
      host: host,
      sso_path: "/sso",
      slo_path: "/slo",
      metadata_path: "/metadata",
      digest_method: Spid::SHA256,
      signature_method: Spid::RSA_SHA256,
      private_key_file_path: generate_fixture_path("private-key.pem"),
      certificate_file_path: generate_fixture_path("certificate.pem")
    )
  end
  let(:host) { "https://service.provider" }
  let(:saml_settings) do
    sso_request.saml_settings
  end

  it { is_expected.to be_a described_class }

  it "requires a body" do
    expect(sso_response.body).to eq spid_response
  end

  it "requires a saml_settings configuration" do
    expect(sso_response.sso_settings).to eq saml_settings
  end

  context "when response conforms to the request" do
    it { is_expected.to be_valid }
  end

  context "when response isn't conform to the request" do
    let(:host) { "https://another-service.provider" }

    it { is_expected.not_to be_valid }
  end
end
