# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::AuthnRequest do
  shared_examples "has attributes" do |attributes|
  end

  subject(:authn_request) do
    described_class.new(
      uuid: "unique-uuid",
      settings: settings
    )
  end

  let(:settings) do
    instance_double(
      "Spid::Saml2::Settings",
      idp_entity_id: "https://identity.provider",
      sp_entity_id: "https://service.provider",
      acs_index: "0"
    )
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

    let(:node) do
      xml_document.elements[xpath]
    end

    describe "samlp:AuthnRequest node" do
      let(:xpath) { "/samlp:AuthnRequest" }

      it "exists" do
        expect(node).not_to be_nil
      end

      it "has 'ID' attribute" do
        attribute = node.attribute("ID")

        expect(attribute).not_to be_nil
        expect(attribute.value).to eq "_unique-uuid"
      end

      it "contains 'Version' attribute" do
        attribute = node.attribute("Version")

        expect(attribute).not_to be_nil
        expect(attribute.value).to eq "2.0"
      end

      it "contains 'IssueInstant' attribute" do
        attribute = node.attribute("IssueInstant")

        expect(attribute).not_to be_nil
        expect(attribute.value).to eq "2018-08-04T00:00:00Z"
      end

      it "contains 'Destination' attribute" do
        attribute = node.attribute("Destination")

        expect(attribute).not_to be_nil
        expect(attribute.value).to eq "https://identity.provider"
      end

      it "contains 'AssertionConsumerServiceIndex' attribute" do
        attr_name = "AssertionConsumerServiceIndex"
        attribute = node.attribute(attr_name)

        expect(attribute).not_to be_nil
        expect(attribute.value).to eq "0"
      end

      it "doens't contain 'IsPassive' attribute" do
        attribute = node.attribute("IsPassive")

        expect(attribute).to be_nil
      end

      xdescribe "contains 'Subject' element"

      describe "samlp:NameIDPolicy" do
        let(:xpath) { super() + "/samlp:NameIDPolicy" }

        it "exists" do
          expect(node).not_to be_nil
        end

        it "doens't contain 'AllowCreate' attribute" do
          attribute = node.attribute("AllowCreate")

          expect(attribute).to be_nil
        end

        it "contains 'Format' attribute" do
          attribute = node.attribute("Format")

          expect(attribute).not_to be_nil
          expect(attribute.value).
            to eq "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
        end
      end

      describe "saml:Issuer element" do
        let(:xpath) { super() + "/saml:Issuer" }

        it "exists" do
          expect(node).not_to be_nil
        end

        it "contains the service provider entity id value" do
          expect(node.text).to eq "https://service.provider"
        end

        it "contains 'Format' attribute" do
          attribute = node.attribute("Format")

          expect(attribute).not_to be_nil
          expect(attribute.value).
            to eq "urn:oasis:names:tc:SAML:2.0:nameid-format:entity"
        end

        it "contains 'NameQualifier' attribute" do
          attribute = node.attribute("NameQualifier")

          expect(attribute).not_to be_nil
          expect(attribute.value).to eq "https://service.provider"
        end
      end
    end
  end
end
