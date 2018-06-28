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
      let(:attributes) { authn_request_node.attributes }

      it "exists" do
        expect(authn_request_node.name).to eq "AuthnRequest"
      end

      it "contains attribute ID in uuid format" do
        regexp = /_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
        expect(attributes["ID"].value).to match regexp
      end

      it "contains attribute Version with value '2.0'" do
        expect(attributes["Version"].value).to eq "2.0"
      end

      it "contains attribute IssueInstant with value equalt to current time" do
        expect(attributes["IssueInstant"].value).to eq Time.now.utc.iso8601
      end

      it "contains attribute Destination with value 'idp_entity_id" do
        expect(attributes["Destination"].value).to eq idp_sso_target_url
      end

      xit "contains attribute ForceAuthn"
    end
  end
end
