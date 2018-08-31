# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Slo::IdpRequest do
  subject(:slo_request) do
    described_class.new(
      body: response_body,
      session_index: session_index
    )
  end

  let(:response_body) { "SAMLRequest" }
  let(:session_index) { "a-session-index" }

  describe "#service_provider" do
    let(:service_provider) { instance_double("Spid::Saml2::ServiceProvider") }

    let(:spid_configuration) do
      instance_double(
        "Spid::Configuration",
        service_provider: service_provider
      )
    end

    before do
      allow(Spid).to receive(:configuration).and_return(spid_configuration)
    end

    it "returns a service provider configuration" do
      expect(slo_request.service_provider).to eq service_provider
    end
  end

  describe "#identity_provider" do
    let(:identity_provider) { instance_double("Spid::Saml2::IdentityProvider") }
    let(:issuer) { "https://identity.provider" }

    before do
      allow(slo_request).
        to receive(:issuer).and_return(issuer)

      allow(Spid::IdentityProviderManager).
        to receive(:find_by_entity).with(issuer).and_return(identity_provider)
    end

    it "returns the identity_provider with provided name" do
      expect(slo_request.identity_provider).to eq identity_provider
    end
  end
end
