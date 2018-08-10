# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::AuthnRequest do
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
      authn_context: Spid::L1,
      acs_index: "0",
      force_authn?: force_authn?
    )
  end

  let(:force_authn?) { false }

  it { is_expected.to be_a described_class }

  before do
    Timecop.freeze
    Timecop.travel("2018-08-04 01:00 +01:00")
  end

  after do
    Timecop.return
  end

  describe "#to_saml" do
    let(:saml_message) { authn_request.to_saml }

    let(:xml_document) { REXML::Document.new(saml_message) }

    let(:node) do
      xml_document.elements[xpath]
    end

    describe "samlp:AuthnRequest node" do
      let(:xpath) { "/samlp:AuthnRequest" }

      it "exists" do
        expect(node).not_to be_nil
      end

      {
        "ID" => "_unique-uuid",
        "Version" => "2.0",
        "IssueInstant" => "2018-08-04T00:00:00Z",
        "Destination" => "https://identity.provider",
        "AssertionConsumerServiceIndex" => "0"
      }.each do |name, value|
        include_examples "has attribute", name, value
      end

      include_examples "hasn't attribute", "isPassive"

      pending "contains 'AttributeConsumingServiceIndex' attribute"

      describe "samlp:NameIDPolicy" do
        let(:xpath) { super() + "/samlp:NameIDPolicy" }

        it "exists" do
          expect(node).not_to be_nil
        end

        include_examples "hasn't attribute", "AllowCreate"

        include_examples "has attribute",
                         "Format",
                         "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
      end

      describe "saml:Issuer element" do
        let(:xpath) { super() + "/saml:Issuer" }

        it "exists" do
          expect(node).not_to be_nil
        end

        it "contains the service provider entity id value" do
          expect(node.text).to eq "https://service.provider"
        end

        {
          "Format" => "urn:oasis:names:tc:SAML:2.0:nameid-format:entity",
          "NameQualifier" => "https://service.provider"
        }.each do |name, value|
          include_examples "has attribute", name, value
        end
      end

      describe "samlp:RequestedAuthnContext element" do
        let(:xpath) { super() + "/samlp:RequestedAuthnContext" }

        it "exists" do
          expect(node).not_to be_nil
        end

        include_examples "has attribute",
                         "Comparison",
                         Spid::MINIMUM_COMPARISON.to_s

        describe "saml:AuthnContextClassRef element" do
          let(:xpath) { super() + "/saml:AuthnContextClassRef" }

          it "exists" do
            expect(node).not_to be_nil
          end
        end
      end

      pending "contains 'Subject' element"

      pending "contains 'Conditions' elements"

      pending "contains 'Signature' element"

      pending "contains 'Scoping' element"

      pending "contains 'RequesterID' element"
    end
  end
end
