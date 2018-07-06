# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::IdentityProviders do
  it { is_expected.to be_a described_class }

  describe ".fetch_all" do
    let(:result) { described_class.fetch_all }

    it "returns an array of identity providers", :vcr do
      expect(result).to include a_hash_including(
        name: "aruba",
        entity_id: "https://loginspid.aruba.it",
        metadata_url: "https://loginspid.aruba.it/metadata"
      )
    end
  end
end
