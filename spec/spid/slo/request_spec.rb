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

  let(:idp_name) { "https://identity.provider" }
  let(:relay_state) { "/path/to/return" }
  let(:session_index) { "session-index" }
  let(:signature_method) { Spid::RSA_SHA256 }
  let(:private_key) { File.read(generate_fixture_path("private-key.pem")) }

  it { is_expected.to be_a described_class }

  describe "#url" do
    let(:settings) do
      instance_double(
        "Spid::Saml2::Settings",
        idp_slo_target_url: "https://identity.provider/slo"
      )
    end

    let(:query_params_signer) do
      instance_double(
        "Spid::Saml2::Utils::QueryParamsSigner",
        escaped_signed_query_string: "params=value"
      )
    end

    before do
      allow(slo_request).
        to receive(:query_params_signer).and_return(query_params_signer)

      allow(slo_request).to receive(:settings).and_return(settings)
    end

    it "returns the slo authentication url for idp" do
      expect(slo_request.url).to eq "https://identity.provider/slo?params=value"
    end
  end

  describe "#query_params_signer" do
    let(:settings) do
      instance_double(
        "Spid::Saml2::Settings",
        signature_method: signature_method,
        private_key: private_key
      )
    end

    let(:saml_message) { double }

    let(:expected_params) do
      {
        saml_message: saml_message,
        relay_state: relay_state,
        signature_method: signature_method,
        private_key: private_key
      }
    end

    before do
      allow(slo_request).to receive(:saml_message).and_return(saml_message)
      allow(slo_request).to receive(:settings).and_return(settings)

      allow(Spid::Saml2::Utils::QueryParamsSigner).to receive(:new)
    end

    it "create a query params signer with attributes" do
      slo_request.query_params_signer

      expect(Spid::Saml2::Utils::QueryParamsSigner).
        to have_received(:new).
        with(expected_params)
    end
  end

  describe "#settings" do
    let(:identity_provider) { double }
    let(:service_provider) { double }

    let(:expected_params) do
      {
        service_provider: service_provider,
        identity_provider: identity_provider
      }
    end

    before do
      allow(slo_request).
        to receive(:identity_provider).and_return(identity_provider)

      allow(slo_request).
        to receive(:service_provider).and_return(service_provider)

      allow(Spid::Saml2::Settings).to receive(:new)
    end

    it "provide attributes to settings object" do
      slo_request.settings

      expect(Spid::Saml2::Settings).
        to have_received(:new).
        with(expected_params)
    end
  end

  describe "#logout_request" do
    let(:settings) { double }
    let(:session_index) { "a-session-index" }

    before do
      allow(slo_request).to receive(:settings).and_return(settings)
      allow(slo_request).to receive(:session_index).and_return(session_index)

      allow(Spid::Saml2::LogoutRequest).to receive(:new)
    end

    it "creates a LogoutRequest with settings" do
      slo_request.logout_request

      expect(Spid::Saml2::LogoutRequest).
        to have_received(:new).
        with(settings: settings, session_index: session_index)
    end
  end

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
        to receive(:find_by_entity).
        with(idp_name).
        and_return(identity_provider)
    end

    it "returns the identity_provider with provided name" do
      expect(slo_request.identity_provider).to eq identity_provider
    end
  end
end
