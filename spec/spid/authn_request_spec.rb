# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::AuthnRequest do
  subject { described_class.new authn_request_options }
  let(:authn_request_options) do
    {
      idp_sso_target_url: idp_sso_target_url
    }
  end
  let(:idp_sso_target_url) { "https://identity.provider/sso" }

  it { is_expected.to be_a described_class }

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
