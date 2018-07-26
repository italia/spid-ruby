require "spec_helper"

RSpec.describe Spid::ServiceProviderManager do
  before do
    Spid.configure do |config|
      config.sp_configuration_file_path = config_file_path
    end
  end

  let(:config_file_path) do
    generate_fixture_path("config/service_providers.yaml")
  end

  let(:certificate_dir_path) do
    generate_fixture_path("config")
  end

  describe ".find_by_host" do
    let(:sp) { described_class.find_by_host(host) }

    context "when a valid service provider host is provider" do
      let(:host) { "https://service.provider" }

      it "returns the service provider configuration" do
        expect(sp.host).to be_present
        expect(sp.host).to eq host
      end
    end

    context "when a not valid service provider host is provided" do
      let(:host) { "https://another.hostname" }

      it "returns nil" do
        expect(sp).to eq nil
      end
    end
  end
end
