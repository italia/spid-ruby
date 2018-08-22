# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::LogoutResponse do
  subject(:logout_response) do
    described_class.new(body: response_body)
  end

  let(:response_body) do
    File.read(generate_fixture_path("slo-response.base64"))
  end

  it { is_expected.to be_a described_class }

  describe "#issuer" do
    it "returns the issuer of the response" do
      expect(logout_response.issuer).to eq "https://identity.provider"
    end
  end
end
