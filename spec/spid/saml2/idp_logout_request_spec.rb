# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::IdpLogoutRequest do
  subject(:request) { described_class.new(saml_message: saml_message) }

  let(:certificate) do
    OpenSSL::X509::Certificate.new(certificate_pem)
  end
  let(:certificate_pem) do
    File.read(generate_fixture_path("idp-certificate.pem"))
  end
  let(:saml_message) do
    File.read(generate_fixture_path("slo-request-signed.xml"))
  end

  it { is_expected.to be_a described_class }

  it "require a saml message" do
    expect(request.saml_message).to eq saml_message
  end

  describe "#id" do
    it "returns the id of the logout request" do
      expect(request.id).to eq "pfx2eef6cbc-8e98-306a-bc77-aebe0c09e753"
    end
  end

  describe "#issue_instant" do
    it "returns the issuer_instant of the logout request" do
      expect(request.issue_instant).to eq "2014-07-18T01:13:06Z"
    end
  end

  describe "#destination" do
    it "returns the destination of the logout request" do
      expect(request.destination).to eq "https://service.provider/spid/slo"
    end
  end

  describe "#issuer" do
    it "returns the issuer of the logout request" do
      expect(request.issuer).to eq "https://identity.provider"
    end
  end

  describe "#session_index" do
    it "returns the session_index of the logout request" do
      expect(request.session_index).
        to eq "_ae6d6510-7de1-41dd-b247-a82e48b6dfc4"
    end
  end

  describe "#issuer_name_qualifier" do
    it "returns the issuer_name_qualifier of the logout request" do
      expect(request.issuer_name_qualifier).to eq "https://identity.provider"
    end
  end

  describe "#name_id" do
    it "returns the issuer_name_qualifier of the logout request" do
      expect(request.name_id).
        to eq "_f92cc1834efc0f73e9c09f482fce80037a6251e7"
    end
  end

  describe "#name_id_name_qualifier" do
    it "returns the name_id_name_qualifier of the logout request" do
      expect(request.name_id_name_qualifier).to eq "https://identity.provider"
    end
  end
end
