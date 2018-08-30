# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::Response do
  subject(:response) do
    described_class.new(saml_message: saml_message)
  end

  let(:saml_message) do
    File.read(generate_fixture_path("sso-response-signed.xml"))
  end

  let(:certificate_pem) do
    File.read(generate_fixture_path("idp-certificate.pem"))
  end

  let(:certificate) do
    OpenSSL::X509::Certificate.new(certificate_pem)
  end

  it { is_expected.to be_a described_class }

  it "requires a saml_message" do
    expect(response.saml_message).to eq saml_message
  end

  describe "#issuer" do
    it "returns the issuer of the response" do
      expect(response.issuer).to eq "https://identity.provider"
    end
  end

  describe "#name_id" do
    it "returns the name_id of the response" do
      expect(response.name_id).
        to eq "_ce3d2948b4cf20146dee0a0b3dd6f69b6cf86f62d7"
    end
  end

  describe "#certificate" do
    it "returns the certificate of the response" do
      expect(response.certificate.to_der).to eq certificate.to_der
    end
  end

  describe "#destination" do
    it "returns the destination of the response" do
      expect(response.destination).to eq "https://service.provider/spid/sso"
    end
  end

  describe "#assertion_issuer" do
    it "returns the assertion issuer of the message" do
      expect(response.assertion_issuer).to eq "https://identity.provider"
    end
  end

  describe "#conditions_not_before" do
    it "returns the not before attribute of conditions node" do
      expect(response.conditions_not_before).
        to eq "2014-07-17T01:01:18Z"
    end
  end

  describe "#conditions_not_on_or_after" do
    it "returns the not on or after attribute of conditions node" do
      expect(response.conditions_not_on_or_after).
        to eq "2024-01-18T06:21:48Z"
    end
  end

  describe "#audience" do
    it "returns the response audience" do
      expect(response.audience).to eq "https://service.provider"
    end
  end

  describe "#session_index" do
    it "returns the session index" do
      expect(response.session_index).
        to eq "_be9967abd904ddcae3c0eb4189adbe3f71e327cf93"
    end
  end

  describe "#status_code" do
    it "returns the status code" do
      expect(response.status_code).to eq Spid::SUCCESS_CODE
    end
  end

  describe "#status_message" do
    it "returns the status message" do
      expect(response.status_message).to be_nil
    end
  end

  describe "#status_detail" do
    it "returns the status detail" do
      expect(response.status_detail).to be_nil
    end
  end

  describe "#attributes" do
    let(:expected_attributes) do
      a_hash_including(
        "familyName" => "Rossi",
        "spidCode" => "ABCDEFGHILMNOPQ"
      )
    end

    it "returns assertion attributes" do
      expect(response.attributes).to match expected_attributes
    end
  end
end
