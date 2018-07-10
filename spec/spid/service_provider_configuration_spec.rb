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
      certificate_file_path: certificate_file_path,
      digest_method: digest_method,
      signature_method: signature_method
    }
  end

  let(:host) { "https://service.provider" }
  let(:sso_path) { "/sso" }
  let(:slo_path) { "/slo" }
  let(:metadata_path) { "/metadata" }
  let(:private_key_file_path) { "/path/to/private/key.pem" }
  let(:certificate_file_path) { "/path/to/certificate.pem" }
  let(:digest_method) { Spid::SHA256 }
  let(:signature_method) { Spid::RSA_SHA256 }

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

  it "requires a digest method" do
    expect(sp_configuration.digest_method).to eq digest_method
  end

  it "requires a signature method" do
    expect(sp_configuration.signature_method).to eq signature_method
  end

  context "with invalid digest methods" do
    let(:digest_method) { "a-not-valid-digest-method" }

    it "raises a Spid::NotValidDigestMethodError" do
      expect { sp_configuration }.
        to raise_error Spid::UnknownDigestMethodError
    end
  end

  context "with invalid signature methods" do
    let(:signature_method) { "a-not-valid-signature-method" }

    it "raises a Spid::UnknownSignatureMethodError" do
      expect { sp_configuration }.
        to raise_error Spid::UnknownSignatureMethodError
    end
  end

  describe "#sso_url" do
    it "generates the sso url" do
      expect(sp_configuration.sso_url).to eq "https://service.provider/sso"
    end
  end

  describe "#sso_url" do
    it "generates the slo url" do
      expect(sp_configuration.slo_url).to eq "https://service.provider/slo"
    end
  end

  describe "#sso_url" do
    it "generates the metadata url" do
      expect(sp_configuration.metadata_url).to eq "https://service.provider/metadata"
    end
  end

  describe "#private_key" do
    let(:private_key_content) { "private_key_content" }

    let(:private_key_tempfile) do
      Tempfile.new("private_key.pem").tap do |file|
        file.write private_key_content
        file.close
      end
    end

    let(:private_key_file_path) { private_key_tempfile.path }

    it "returns the filecontent" do
      expect(sp_configuration.private_key).to eq private_key_content
    end

    after { private_key_tempfile.unlink }
  end

  describe "#certificate" do
    let(:certificate_content) { "certificate_content" }

    let(:certificate_tempfile) do
      Tempfile.new("certificate.pem").tap do |file|
        file.write certificate_content
        file.close
      end
    end

    let(:certificate_file_path) { certificate_tempfile.path }

    it "returns the filecontent" do
      expect(sp_configuration.certificate).to eq certificate_content
    end

    after { certificate_tempfile.unlink }
  end
end
