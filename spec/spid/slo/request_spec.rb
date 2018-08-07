# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Slo::Request do
  subject(:slo_request) do
    described_class.new(
      idp_name: idp_name,
      session_index: session_index,
      relay_state: relay_state
    )
  end

  let(:idp_name) { "idp-name" }
  let(:relay_state) { "/path/to/return" }
  let(:session_index) { "session-index" }

  it { is_expected.to be_a described_class }

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

    before do
      allow(Spid::IdentityProviderManager).
        to receive(:find_by_name).
        with(idp_name).
        and_return(identity_provider)
    end

    it "returns the identity_provider with provided name" do
      expect(slo_request.identity_provider).to eq identity_provider
    end
  end

  describe "#url" do
    let(:logout_request) do
      instance_double("Spid::LogoutRequest")
    end

    let(:saml_settings) { instance_double("::OneLogin::RubySaml::Settings") }

    let(:saml_object) { "<saml></saml>" }

    before do
      allow(slo_request).to receive(:logout_request).and_return(logout_request)

      allow(slo_request).to receive(:saml_settings).and_return(saml_settings)

      allow(logout_request).
        to receive(:create).with(saml_settings, "RelayState" => relay_state).
        and_return(saml_object)
    end

    it "returns the saml object" do
      expect(slo_request.url).to eq saml_object
    end
  end

  describe "#slo_settings" do
    let(:identity_provider) { instance_double("Spid::Saml2::IdentityProvider") }
    let(:service_provider) { instance_double("Spid::Saml2::ServiceProvider") }
    let(:expected_params) do
      {
        service_provider: service_provider,
        identity_provider: identity_provider,
        session_index: session_index
      }
    end

    before do
      allow(slo_request).
        to receive(:identity_provider).and_return(identity_provider)

      allow(slo_request).
        to receive(:service_provider).and_return(service_provider)

      allow(Spid::Slo::Settings).to receive(:new)
    end

    it "returns a new Spid::Slo::Settings instance with specific values" do
      slo_request.slo_settings

      expect(Spid::Slo::Settings).to have_received(:new).with(expected_params)
    end
  end
end
