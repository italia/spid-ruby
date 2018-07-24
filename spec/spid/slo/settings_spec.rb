# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Slo::Settings do
  subject(:slo_settings) do
    described_class.new(slo_attributes.merge(optional_slo_attributes))
  end

  let(:slo_attributes) do
    {
      service_provider_configuration: service_provider_configuration,
      identity_provider_configuration: identity_provider_configuration,
      session_index: session_index
    }
  end

  let(:optional_slo_attributes) { {} }

  let(:identity_provider_configuration) do
    instance_double(
      "Spid::IdentityProviderConfiguration",
      slo_target_url: "https://identity.provider/slo",
      entity_id: "https://identity.provider",
      cert_fingerprint: "certificate-fingerprint"
    )
  end

  let(:service_provider_configuration) do
    instance_double(
      "Spid::ServiceProviderConfiguration",
      host: "https://service.provider",
      private_key: "a-private-key",
      certificate: "a-certificate",
      digest_method: "a-digest-method",
      signature_method: "a-signature-method"
    )
  end

  let(:session_index) { "session-index-value" }

  it { is_expected.to be_a described_class }

  it "requires a service provider configuration" do
    expect(slo_settings.service_provider_configuration).
      to eq service_provider_configuration
  end

  it "requires a identity provider configuration" do
    expect(slo_settings.identity_provider_configuration).
      to eq identity_provider_configuration
  end

  it "requires a session index" do
    expect(slo_settings.session_index).to eq session_index
  end
end
