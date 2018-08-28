# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::Response do
  subject(:response) do
    described_class.new(saml_message: saml_message)
  end

  let(:saml_message) do
    File.read(generate_fixture_path("sso-response-signed.xml"))
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
