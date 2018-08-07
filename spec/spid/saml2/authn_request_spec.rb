# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::AuthnRequest do
  shared_examples "has attributes" do |attributes|
  end

  subject(:authn_request) do
    described_class.new(uuid: "unique-uuid")
  end

  it { is_expected.to be_a described_class }

  before do
    Timecop.freeze
    Timecop.travel("2018-08-04 01:00 +01:00")
  end

  after do
    Timecop.return
  end

  describe "#to_saml" do
    let(:xml_document) do
      authn_request.to_saml
    end

    describe "samlp:AuthnRequest node" do
      let(:authn_request_node) do
        xml_document.elements["/samlp:AuthnRequest"]
      end

      it "exists" do
        expect(authn_request_node).not_to be_nil
      end

      it "has 'ID' attribute" do
        attribute = authn_request_node.attribute("ID")

        expect(attribute).not_to be_nil
        expect(attribute.value).to eq "_unique-uuid"
      end

      it "contains 'Version' attribute" do
        attribute = authn_request_node.attribute("Version")

        expect(attribute).not_to be_nil
        expect(attribute.value).to eq "2.0"
      end

      it "contains 'IssueInstant' attribute" do
        attribute = authn_request_node.attribute("IssueInstant")

        expect(attribute).not_to be_nil
        expect(attribute.value).to eq "2018-08-04T00:00:00Z"
      end
    end
  end
end
