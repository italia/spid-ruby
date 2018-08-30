# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::IdpMetadataParser do
  subject(:parser) { described_class.new }

  it { is_expected.to be_a described_class }

  describe "#parse_to_hash" do
    let(:metadata_file_path) do
      generate_fixture_path("config/idp_metadata/#{metadata_name}")
    end

    let(:metadata_name) { "identity-provider-metadata.xml" }

    let(:metadata) do
      File.read(metadata_file_path)
    end

    let(:parsed_settings) do
      parser.parse_to_hash(metadata)
    end

    let(:certificate) do
      parsed_settings[:idp_cert]
    end

    let(:expected_settings) do
      a_hash_including(
        idp_entity_id: "https://identity.provider",
        idp_slo_target_url: "https://identity.provider/slo",
        idp_sso_target_url: "https://identity.provider/sso"
      )
    end

    it "returns the identity provider settings" do
      expect(parsed_settings).to match expected_settings
    end

    it "contains a certificate" do
      expect(certificate.serial.to_s).to eq "16658553563499953376"
    end

    context "when certificate is in encryption descriptor" do
      let(:metadata_name) { "another-identity-provider-metadata.xml" }

      it "contains a certificate" do
        expect(certificate.serial.to_s).to eq "16658553563499953376"
      end
    end
  end
end
