# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Slo::Settings do
  subject(:slo_settings) do
    described_class.new(slo_attributes.merge(optional_slo_attributes))
  end

  let(:slo_attributes) do
    {
      service_provider: service_provider,
      identity_provider_configuration: identity_provider_configuration,
      session_index: session_index
    }
  end

  let(:optional_slo_attributes) { {} }

  let(:identity_provider_configuration) do
    instance_double(
      "Spid::IdentityProviderConfiguration",
      slo_attributes: {
        idp_slo_target_url: "https://identity.provider/slo",
        idp_name_qualifier: "https://identity.provider",
        idp_cert_fingerprint: "certificate-fingerprint"
      }
    )
  end

  let(:service_provider) do
    instance_double(
      "Spid::ServiceProvider",
      slo_attributes: {
        issuer: "https://service.provider",
        private_key: "a-private-key",
        certificate: "a-certificate",
        security: {
          logout_requests_signed: true,
          embed_sign: true,
          digest_method: "a-digest-method",
          signature_method: "a-signature-method"
        }
      }
    )
  end

  let(:session_index) { "session-index-value" }

  it { is_expected.to be_a described_class }

  it "requires a service provider configuration" do
    expect(slo_settings.service_provider).
      to eq service_provider
  end

  it "requires a identity provider configuration" do
    expect(slo_settings.identity_provider_configuration).
      to eq identity_provider_configuration
  end

  it "requires a session index" do
    expect(slo_settings.session_index).to eq session_index
  end
end
