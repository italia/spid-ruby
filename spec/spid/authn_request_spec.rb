# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::AuthnRequest do
  subject { described_class.new authn_request_options }

  let(:authn_request_options) do
    {
      idp_sso_target_url: idp_sso_target_url,
      assertion_consumer_service_url: sp_sso_target_url
    }
  end

  let(:idp_sso_target_url) { "https://identity.provider/sso" }
  let(:sp_sso_target_url) { "https://service.provider/sso" }

  it { is_expected.to be_a described_class }

  describe "#to_xml" do
    let(:xml_document) { subject.to_xml }
    let(:document_node) do
      Nokogiri::XML(
        xml_document.to_s
      )
    end

    describe "AuthnRequest node" do
      let(:authn_request_node) { document_node.root }
      let(:attributes) { authn_request_node.attributes }

      it "exists" do
        expect(authn_request_node.name).to eq "AuthnRequest"
      end

      it "contains attribute ID" do
        regexp = /_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
        expect(attributes["ID"].value).to match regexp
      end

      it "contains attribute Version" do
        expect(attributes["Version"].value).to eq "2.0"
      end

      it "contains attribute IssueInstant" do
        expect(attributes["IssueInstant"].value).to eq Time.now.utc.iso8601
      end

      it "contains attribute Destination" do
        expect(attributes["Destination"].value).to eq idp_sso_target_url
      end

      xit "contains attribute ForceAuthn"

      it "contains attribute AssertionConsumerServiceURL" do
        attribute = attributes["AssertionConsumerServiceURL"].value
        expect(attribute).to eq sp_sso_target_url
      end

      it "contains attribute ProtocolBinding" do
        attribute = attributes["ProtocolBinding"].value
        expect(attribute).to eq "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
      end

      xit "contains attribute AttributeConsumingServiceIndex"
    end
  end
end
