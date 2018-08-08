# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::Utils::DeflatedEncode do
  subject(:encoder) do
    described_class.new(message: message)
  end

  let(:message) { "<samlp:AuthnRequest />" }

  it { is_expected.to be_a described_class }

  describe "#encode" do
    it "encodes the message in base 64 after deflation" do
      expect(encoder.encode).to eq "sylOzM0psHIsLcnIC0otLE0tLlHQtwMA"
    end
  end
end
