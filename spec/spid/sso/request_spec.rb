# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Sso::Request do
  subject(:sso_request) do
    described_class.new(
      idp_name: idp_name,
      relay_state: relay_state,
      authn_context: authn_context
    )
  end

  let(:idp_name) { "idp-name" }
  let(:relay_state) { "/path/to/return" }
  let(:authn_context) { Spid::L1 }

  it { is_expected.to be_a described_class }

  describe "#service_provider" do
    let(:service_provider) { instance_double("Spid::ServiceProvider") }

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
      expect(sso_request.service_provider).to eq service_provider
    end
  end

  describe "#identity_provider" do
    let(:identity_provider) { instance_double("Spid::IdentityProvider") }

    before do
      allow(Spid::IdentityProviderManager).
        to receive(:find_by_name).
        with(idp_name).
        and_return(identity_provider)
    end

    it "returns the identity_provider with provided name" do
      expect(sso_request.identity_provider).to eq identity_provider
    end
  end

  describe "#to_saml" do
    let(:authn_request) do
      instance_double("Spid::AuthnRequest")
    end

    let(:saml_settings) { instance_double("::OneLogin::RubySaml::Settings") }

    let(:saml_object) { "<saml></saml>" }

    let(:antani) { sso_request }

    before do
      allow(sso_request).to receive(:authn_request).and_return(authn_request)

      allow(sso_request).to receive(:saml_settings).and_return(saml_settings)

      allow(authn_request).
        to receive(:create).with(saml_settings, "RelayState" => relay_state).
        and_return(saml_object)
    end

    it "returns the saml object" do
      expect(sso_request.to_saml).to eq saml_object
    end
  end

  describe "#sso_settings" do
    let(:identity_provider) { instance_double("Spid::IdentityProvider") }
    let(:service_provider) { instance_double("Spid::ServiceProvider") }

    let(:expected_params) do
      {
        service_provider: service_provider,
        identity_provider: identity_provider,
        authn_context: authn_context
      }
    end

    before do
      allow(sso_request).
        to receive(:identity_provider).and_return(identity_provider)

      allow(sso_request).
        to receive(:service_provider).and_return(service_provider)

      allow(Spid::Sso::Settings).to receive(:new)
    end

    it "returns a new Spid::Sso::Settings instance with specific values" do
      sso_request.sso_settings

      expect(Spid::Sso::Settings).to have_received(:new).with(expected_params)
    end
  end
end
