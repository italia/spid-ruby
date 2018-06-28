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
    let(:document_node) do
      Nokogiri::XML(
        subject.to_xml.to_s
      )
    end

    describe "AuthnRequest node" do
      let(:authn_request_node) { document_node.root }

      it "exists" do
        expect(authn_request_node.name).to eq "AuthnRequest"
      end
    end
  end
end
