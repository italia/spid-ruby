# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::IdentityProviderConfiguration do
  subject(:identity_provider_configuration) do
    described_class.new idp_metadata: idp_metadata
  end

  let(:idp_metadata) do
    File.read(generate_fixture_path("idp_metadata.xml"))
  end

  it { is_expected.to be_a described_class }

  it "requires an idp_metadata" do
    expect(identity_provider_configuration.idp_metadata).to eq idp_metadata
  end

  describe "#entity_id" do
    it "returns the entity_id parsed from metadata" do
      expect(identity_provider_configuration.entity_id).
        to eq "spid-testenv-identityserver"
    end
  end

  describe "#sso_target_url" do
    it "returns the sso_target_url of the identity provider" do
    end
  end
end
