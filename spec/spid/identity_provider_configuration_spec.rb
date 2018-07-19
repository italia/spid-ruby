# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::IdentityProviderConfiguration do
  subject(:idp_configuration) do
    described_class.new identity_provider_attributes
  end

  let(:identity_provider_attributes) do
    {
      name: name,
      entity_id: entity_id,
      sso_target_url: sso_target_url,
      slo_target_url: slo_target_url,
      cert_fingerprint: cert_fingerprint
    }
  end

  let(:name) { "idp-name" }
  let(:entity_id) { "https://example.com" }
  let(:sso_target_url) { "#{entity_id}/sso-path" }
  let(:slo_target_url) { "#{entity_id}/slo-path" }
  let(:cert_fingerprint) { "a-certificate-fingerprint" }

  let(:idp_metadata) do
    File.read(generate_fixture_path("identity-provider-metadata.xml"))
  end

  it { is_expected.to be_a described_class }

  it "requires a name" do
    expect(idp_configuration.name).to eq name
  end

  it "requires an entity_id" do
    expect(idp_configuration.entity_id).to eq entity_id
  end

  it "requires an sso_target_url" do
    expect(idp_configuration.sso_target_url).to eq sso_target_url
  end

  it "requires an slo_target_url" do
    expect(idp_configuration.slo_target_url).to eq slo_target_url
  end

  it "requires an cert_fingerprint" do
    expect(idp_configuration.cert_fingerprint).to eq cert_fingerprint
  end

  describe ".parse_from_xml" do
    let(:result) do
      described_class.parse_from_xml(metadata: idp_metadata, name: name)
    end

    let(:entity_id) { "https://identity.provider" }
    let(:sso_target_url) { "https://identity.provider/sso" }
    let(:slo_target_url) { "https://identity.provider/slo" }
    let(:cert_fingerprint) do
      "C6:82:11:E5:44:22:53:58:05:B2:3F:2D:24:52:8B:17:95:C3:62:89"
    end

    before do
      allow(described_class).to receive(:new)
    end

    it "creates a new idp configuration with metadata attributes" do
      result
      expect(described_class).
        to have_received(:new).
        with a_hash_including identity_provider_attributes
    end
  end
end
