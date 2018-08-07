# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::Settings do
  subject(:settings) do
    described_class.new(
      identity_provider: identity_provider
    )
  end

  let(:identity_provider) do
    instance_double(
      "Spid::Saml2::IdentityProvider",
      entity_id: "https://identity.provider"
    )
  end

  it { is_expected.to be_a described_class }

  describe "#idp_entity_id" do
    it "returns the identity provider entity id" do
      expect(settings.idp_entity_id).to eq "https://identity.provider"
    end
  end
end
