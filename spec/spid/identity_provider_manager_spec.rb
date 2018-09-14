# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::IdentityProviderManager do
  before do
    Spid.configure do |config|
      config.idp_metadata_dir_path = metadata_dir_path
    end
  end

  let(:idp_metadata) do
    File.read(metadata_file_path)
  end

  let(:metadata_dir_path) do
    generate_fixture_path("config/idp_metadata")
  end

  let(:metadata_file_path) do
    generate_fixture_path(
      "config/idp_metadata/identity-provider-metadata.xml"
    )
  end

  after do
    Spid.reset_configuration!
  end

  describe ".find_by_entity_id" do
    let(:idp) { described_class.find_by_entity(entity_id) }

    context "when a valid issuer_id is provided" do
      let(:entity_id) { "https://identity.provider" }

      it "returns the identity provider configuration" do
        expect(idp.entity_id).to eq entity_id
      end
    end

    context "when a not valid issuer_id is provided" do
      let(:entity_id) { "https://another-identity.provider" }

      it "returns nil" do
        expect(idp).to eq nil
      end
    end
  end

  describe ".parse_from_xml" do
    let(:result) do
      described_class.parse_from_xml(metadata: idp_metadata)
    end

    let(:entity_id) { "https://identity.provider" }
    let(:sso_target_url) { "https://identity.provider/sso" }
    let(:slo_target_url) { "https://identity.provider/slo" }

    let(:certificate) do
      instance_double("OpenSSL::X509::Certificate")
    end

    let(:expected_param) do
      {
        entity_id: entity_id,
        sso_target_url: sso_target_url,
        slo_target_url: slo_target_url,
        certificate: OpenSSL::X509::Certificate
      }
    end

    before do
      allow(Spid::Saml2::IdentityProvider).to receive(:new)
    end

    it "creates a new idp configuration with metadata attributes" do
      result
      expect(Spid::Saml2::IdentityProvider).
        to have_received(:new).with a_hash_including(expected_param)
    end
  end
end
