# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::IdentityProviderManager do
  before do
    Spid.configure do |config|
      config.idp_metadata_dir_path = metadata_dir_path
    end
  end

  let(:metadata_dir_path) do
    generate_fixture_path("config/idp_metadata")
  end

  describe ".find_by_name" do
    let(:idp) { described_class.find_by_name(idp_name) }

    context "when a valid idp_name is provided" do
      let(:idp_name) { "identity-provider" }

      it "returns the identity provider configuration" do
        expect(idp.name).to eq idp_name
      end
    end

    context "when a not valid idp_name is provided" do
      let(:idp_name) { "not-existing-identity-provider" }

      it "returns nil" do
        expect(idp).to eq nil
      end
    end
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
end
