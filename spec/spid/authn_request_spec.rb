# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::AuthnRequest do
  subject { described_class.new }

  describe "#to_xml" do
    let(:to_xml) do
      Nokogiri::XML(
        subject.to_xml
      )
    end

    it "has a AuthnRequest element as root element" do
      expect(to_xml.root.name).to eq "samlp:AuthnRequest"
    end
  end
end
