# frozen_string_literal: true

RSpec.describe Spid do
  it "has a version number" do
    expect(Spid::VERSION).not_to be nil
  end

  describe Spid::Configuration do
    subject(:config) { described_class.new }

    describe "#sp_certificates_dir_path" do
      it "has a default value" do
        expect(config.sp_certificates_dir_path).to eq "sp_certificates"
      end
    end

    describe "#sp_configuration_file_path" do
      it "has a default value" do
        expect(config.sp_configuration_file_path).to eq "service_providers.yml"
      end
    end

    describe "#idp_metadata_dir_path" do
      it "has a default value" do
        expect(config.idp_metadata_dir_path).to eq "idp_metadata"
      end
    end
  end
end
