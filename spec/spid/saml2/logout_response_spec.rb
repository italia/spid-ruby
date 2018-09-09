# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::LogoutResponse do
  subject(:logout_response) do
    described_class.new(saml_message: saml_message)
  end

  let(:saml_message) do
    File.read(generate_fixture_path("slo-response-signed.xml"))
  end

  it { is_expected.to be_a described_class }

  describe "#issuer" do
    it "returns the issuer of the response" do
      expect(logout_response.issuer).to eq "https://identity.provider"
    end
  end

  describe "#in_response_to" do
    it "returns the associated request id of the response" do
      expect(logout_response.in_response_to).
        to eq "_21df91a89767879fc0f7df6a1490c6000c81644d"
    end
  end

  describe "#destination" do
    it "returns the destination of the response" do
      expect(logout_response.destination).
        to eq "https://service.provider/spid/slo"
    end
  end
end
