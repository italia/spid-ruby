# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::SynchronizeIdpMetadata do
  subject(:command) { described_class.new }

  let(:metadata_dir_path) do
    "/tmp/idp_metadata"
  end

  it { is_expected.to be_a described_class }

  before do
    Spid.configure do |config|
      config.idp_metadata_dir_path = metadata_dir_path
    end
  end

  describe "#idp_list" do
    let(:expected_list) do
      a_hash_including(
        "Aruba ID" =>
          "https://loginspid.aruba.it/metadata",
        "Infocert ID" =>
          "https://identity.infocert.it/metadata/metadata.xml",
        "Intesa ID" =>
          "https://spid.intesa.it/metadata/metadata.xml",
        "Namirial ID" =>
          "https://idp.namirialtsp.com/idp/metadata",
        "Poste ID" =>
          "https://posteid.poste.it/jod-fs/metadata/metadata.xml",
        "Sielte ID"	=>
          "https://identity.sieltecloud.it/simplesaml/metadata.xml",
        "SPIDItalia" =>
          "https://spid.register.it/login/metadata",
        "Tim ID" =>
          "https://login.id.tim.it/spid-services/MetadataBrowser/idp"
      )
    end

    it "returns the idp list of metadata urls", vcr: true do
      expect(command.idp_list).to match expected_list
    end
  end

  describe "#call" do
    let(:metadatas) do
      Dir.chdir(metadata_dir_path) do
        Dir.glob("*.xml")
      end
    end

    let(:expected_metadata) do
      [
        "posteid-metadata.xml",
        "arubaid-metadata.xml",
        "infocertid-metadata.xml",
        "intesaid-metadata.xml",
        "namirialid-metadata.xml",
        "sielteid-metadata.xml",
        "spiditalia-metadata.xml",
        "timid-metadata.xml"
      ]
    end

    it "save in metadata dir path all metadatas", vcr: true do
      command.call
      expect(metadatas).to match_array expected_metadata
    end
  end
end
