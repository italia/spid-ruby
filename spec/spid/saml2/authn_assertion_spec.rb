# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::AuthnAssertion do
  subject(:authn_assertion) do
    described_class.new(body: authn_assertion_body)
  end

  let(:authn_assertion_body) do
    File.read(generate_fixture_path("sso-response.base64"))
  end

  it { is_expected.to be_a described_class }

  it "requires a body" do
    expect(authn_assertion.body).to eq authn_assertion_body
  end

  describe "#issuer" do
    it "returns the issuer of the response" do
      expect(authn_assertion.issuer).to eq "https://identity.provider"
    end
  end

  describe "#assertion_issuer" do
    it "returns the assertion issuer of the message" do
      expect(authn_assertion.assertion_issuer).to eq "https://identity.provider"
    end
  end

  describe "#session_index" do
    it "returns the session index" do
      expect(authn_assertion.session_index).
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
      expect(authn_assertion.attributes).to match expected_attributes
    end
  end
end
