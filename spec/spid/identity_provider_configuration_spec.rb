# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::IdentityProviderConfiguration do
  subject(:identity_provider_configuration) do
    described_class.new idp_metadata: idp_metadata
  end

  let(:idp_metadata) do
    File.read(generate_fixture_path("identity-provider-metadata.xml"))
  end

  it { is_expected.to be_a described_class }

  it "requires an idp_metadata" do
    expect(identity_provider_configuration.idp_metadata).to eq idp_metadata
  end

  describe "#entity_id" do
    it "returns the entity_id parsed from metadata" do
      expect(identity_provider_configuration.entity_id).
        to eq "https://identity.provider"
    end
  end

  describe "#sso_target_url" do
    it "returns the sso_target_url of the identity provider" do
      expect(identity_provider_configuration.sso_target_url).
        to eq "https://identity.provider/sso"
    end
  end

  describe "#cert_fingerprint" do
    it "returns the certificate fingerprint" do
      expect(identity_provider_configuration.cert_fingerprint).
        to eq "C6:82:11:E5:44:22:53:58:05:B2:3F:2D:24:52:8B:17:95:C3:62:89"
    end
  end
end
