# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::IdpMetadata do
  subject(:idp_metadata) { described_class.instance }

  before do
    allow(Spid::IdentityProviders).to receive(:fetch_all).and_return(
      [
        {
          name: "aruba",
          entity_id: "https://loginspid.aruba.it",
          metadata_url: "https://loginspid.aruba.it/metadata"
        }
      ]
    )
  end

  it { is_expected.to be_a described_class }

  describe ".[]" do
    it "returns metadata of selected provider", :vcr do
      aruba_metadata = idp_metadata[:aruba]
      expect(aruba_metadata).to be_a Object
    end

    xcontext "providing a non existing identity provider code"
  end
end
