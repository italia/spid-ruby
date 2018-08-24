# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::ServiceProvider do
  subject(:service_provider) { described_class.new service_provider_attributes }

  let(:service_provider_attributes) do
    {
      host: host,
      acs_path: acs_path,
      acs_binding: acs_binding,
      slo_path: slo_path,
      slo_binding: slo_binding,
      metadata_path: metadata_path,
      private_key: private_key,
      certificate: certificate,
      digest_method: digest_method,
      signature_method: signature_method,
      attribute_services: attribute_services
    }
  end

  let(:host) { "https://service.provider" }
  let(:attribute_services) { [{ name: "Service 1", fields: [:email] }] }
  let(:acs_path) { "/sso" }
  let(:acs_binding) { "acs-binding-method" }
  let(:slo_path) { "/slo" }
  let(:slo_binding) { "slo-binding-method" }
  let(:metadata_path) { "/metadata" }
  let(:private_key) { "private_key" }
  let(:certificate) { "certificate" }
  let(:digest_method) { Spid::SHA256 }
  let(:signature_method) { Spid::RSA_SHA256 }

  it { is_expected.to be_a described_class }

  it "requires an host" do
    expect(service_provider.host).to eq host
  end

  it "requires a sso path" do
    expect(service_provider.acs_path).to eq acs_path
  end

  it "requires a slo path" do
    expect(service_provider.slo_path).to eq slo_path
  end

  it "requires a slo binding" do
    expect(service_provider.slo_binding).to eq slo_binding
  end

  it "requires a metadata path" do
    expect(service_provider.metadata_path).to eq metadata_path
  end

  it "requires a private key file path" do
    expect(service_provider.private_key).to eq private_key
  end

  it "requires a certificate file path" do
    expect(service_provider.certificate).to eq certificate
  end

  it "requires a digest method" do
    expect(service_provider.digest_method).to eq digest_method
  end

  it "requires a signature method" do
    expect(service_provider.signature_method).to eq signature_method
  end

  it "requires a attribute_services" do
    expect(service_provider.attribute_services).to eq attribute_services
  end

  context "with invalid digest methods" do
    let(:digest_method) { "a-not-valid-digest-method" }

    it "raises a Spid::NotValidDigestMethodError" do
      expect { service_provider }.
        to raise_error Spid::UnknownDigestMethodError
    end
  end

  context "with invalid signature methods" do
    let(:signature_method) { "a-not-valid-signature-method" }

    it "raises a Spid::UnknownSignatureMethodError" do
      expect { service_provider }.
        to raise_error Spid::UnknownSignatureMethodError
    end
  end

  context "with wrong attribute in attribute services" do
    let(:attribute_services) do
      [
        { name: "Service 1", fields: [:fiscal_number] },
        { name: "Service 2", fields: [:wrong_attribute] }
      ]
    end

    it "raises a Spid::UknownAttributeFieldError" do
      expect { service_provider }.
        to raise_error Spid::UnknownAttributeFieldError
    end
  end

  describe "#acs_url" do
    it "generates the sso url" do
      expect(service_provider.acs_url).to eq "https://service.provider/sso"
    end
  end

  describe "#slot_url" do
    it "generates the slo url" do
      expect(service_provider.slo_url).to eq "https://service.provider/slo"
    end
  end

  describe "#metadata_url" do
    it "generates the metadata url" do
      expect(service_provider.metadata_url).
        to eq "https://service.provider/metadata"
    end
  end
end
