# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::ServiceProviderConfiguration do
  subject(:sp_configuration) { described_class.new service_provider_attributes }

  let(:service_provider_attributes) do
    {
      host: host,
      sso_path: sso_path,
      slo_path: slo_path,
      metadata_path: metadata_path,
      private_key_file_path: private_key_file_path,
      certificate_file_path: certificate_file_path
    }
  end

  let(:host) { "https://service.provider" }
  let(:sso_path) { "/sso" }
  let(:slo_path) { "/slo" }
  let(:metadata_path) { "/metadata" }
  let(:private_key_file_path) { "/path/to/private/key.pem" }
  let(:certificate_file_path) { "/path/to/certificate.pem" }

  it { is_expected.to be_a described_class }

  it "requires an host" do
    expect(sp_configuration.host).to eq host
  end

  it "requires a sso path" do
    expect(sp_configuration.sso_path).to eq sso_path
  end

  it "requires a slo path" do
    expect(sp_configuration.slo_path).to eq slo_path
  end

  it "requires a metadata path" do
    expect(sp_configuration.metadata_path).to eq metadata_path
  end

  it "requires a private key file path" do
    expect(sp_configuration.private_key_file_path).to eq private_key_file_path
  end

  it "requires a certificate file path" do
    expect(sp_configuration.certificate_file_path).to eq certificate_file_path
  end
end
