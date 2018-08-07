# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::Settings do
  subject(:settings) do
    described_class.new(
      authn_context: authn_context,
      identity_provider: identity_provider,
      service_provider: service_provider
    )
  end

  let(:identity_provider) do
    instance_double(
      "Spid::Saml2::IdentityProvider",
      entity_id: "https://identity.provider"
    )
  end

  let(:service_provider) do
    instance_double(
      "Spid::Saml2::ServiceProvider",
      host: "https://service.provider"
    )
  end

  let(:authn_context) { nil }

  it { is_expected.to be_a described_class }

  describe "#idp_entity_id" do
    it "returns the identity provider entity id" do
      expect(settings.idp_entity_id).to eq "https://identity.provider"
    end
  end

  describe "#acs_index" do
    it "returns '0'" do
      expect(settings.acs_index).to eq "0"
    end
  end

  describe "#sp_entity_id" do
    it "returns the service provider entity id" do
      expect(settings.sp_entity_id).to eq "https://service.provider"
    end
  end

  describe "#authn_context" do
    context "when attribute is not provided" do
      it "returns the default authn_context" do
        expect(settings.authn_context).to eq Spid::L1
      end
    end

    context "when attribute is provided" do
      let(:authn_context) { Spid::L3 }

      it "returns provider authn_context" do
        expect(settings.authn_context).to eq Spid::L3
      end
    end
  end
end
