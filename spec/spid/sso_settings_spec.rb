# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::SsoSettings do
  subject(:sso_settings) do
    described_class.new(
      service_provider_configuration: service_provider_configuration,
      identity_provider_configuration: identity_provider_configuration
    )
  end

  let(:identity_provider_configuration) do
    instance_double(
      "Spid::IdentityProviderConfiguration",
      sso_target_url: "https://identity.provider/sso",
      cert_fingerprint: "certificate-fingerprint"
    )
  end
  let(:service_provider_configuration) do
    instance_double(
      "Spid::ServiceProviderConfiguration",
      sso_url: "https://service.provider/sso",
      host: "https://service.provider",
      private_key: "a-private-key",
      certificate: "a-certificate",
      digest_method: "a-digest-method",
      signature_method: "a-signature-method"
    )
  end

  it { is_expected.to be_a described_class }

  it "requires a service provider configuration" do
    expect(sso_settings.service_provider_configuration).
      to eq service_provider_configuration
  end

  it "requires a identity provider configuration" do
    expect(sso_settings.identity_provider_configuration).
      to eq identity_provider_configuration
  end
end
