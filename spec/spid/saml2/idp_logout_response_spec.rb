# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::IdpLogoutResponse do
  subject(:response) do
    described_class.new(
      settings: settings
    )
  end

  let(:response_status) { :success }

  let(:settings) do
    instance_double(
      "Spid::Saml2::Settings",
      sp_entity_id: "https://service.provider"
    )
  end

  it { is_expected.to be_a described_class }

  describe "#to_saml" do
    let(:saml_message) { response.to_saml }

    let(:xml_document) { REXML::Document.new(saml_message) }

    let(:node) { xml_document.elements[xpath] }

    describe "samlp:LogoutResponse" do
      let(:xpath) { "/samlp:LogoutResponse" }

      it "exists" do
        expect(node).not_to be_nil
      end

      describe "saml:Issuer" do
        let(:xpath) { super() + "/saml:Issuer" }

        it "exists" do
          expect(node).not_to be_nil
        end
      end

      describe "saml:Status" do
        let(:xpath) { super() + "/saml:Status" }

        it "exists" do
          expect(node).not_to be_nil
        end

        describe "saml:StatusCode" do
          let(:xpath) { super() + "/saml:StatusCode" }

          it "exists" do
            expect(node).not_to be_nil
          end

          it "contains the Status Code" do
            expect(node.text).
              to eq "urn:oasis:names:tc:SAML:2.0:status:Success"
          end
        end

        pending "saml:Signature"
      end
    end
  end
end
