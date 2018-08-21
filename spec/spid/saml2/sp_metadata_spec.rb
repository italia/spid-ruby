# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::SPMetadata do
  subject(:sp_metadata) do
    described_class.new(
      settings: settings,
      uuid: "unique-uuid"
    )
  end

  let(:settings) do
    instance_double(
      "Spid::Saml2::Settings",
      sp_entity_id: "https://service.provider",
      sp_slo_service_binding: "slo-binding-method",
      x509_certificate_der: "certificate-der"
    )
  end

  it { is_expected.to be_a described_class }

  describe "#to_saml" do
    let(:saml_message) { sp_metadata.to_saml }

    let(:xml_document) { REXML::Document.new(saml_message) }

    let(:node) do
      xml_document.elements[xpath]
    end

    describe "md:EntityDescriptor node" do
      let(:xpath) { "/md:EntityDescriptor" }

      it "exists" do
        expect(node).not_to be_nil
      end

      {
        "EntityID" => "https://service.provider",
        "ID" => "_unique-uuid"
      }.each do |name, value|
        include_examples "has attribute", name, value
      end

      describe "md:SPSSODescriptor node" do
        let(:xpath) { super() + "/md:SPSSODescriptor" }

        it "exists" do
          expect(node).not_to be_nil
        end

        {
          "protocolSupportEnumeration" =>
            "urn:oasis:names:tc:SAML:2.0:protocol",
          "AuthnRequestsSigned" => "true"
        }.each do |name, value|
          include_examples "has attribute", name, value
        end

        describe "md:SingleLogoutService" do
          let(:xpath) { super() + "/md:SingleLogoutService" }

          it "exists" do
            expect(node).not_to be_nil
          end

          {
            "Binding" => "slo-binding-method"
          }.each do |name, value|
            include_examples "has attribute", name, value
          end
        end

        describe "md:KeyDescriptor node" do
          let(:xpath) { super() + "/md:KeyDescriptor" }

          it "exists" do
            expect(node).not_to be_nil
          end

          include_examples "has attribute", "use", "signing"

          describe "ds:KeyInfo node" do
            let(:xpath) { super() + "/ds:KeyInfo" }

            it "exists" do
              expect(node).not_to be_nil
            end

            describe "ds:X509Data" do
              let(:xpath) { super() + "/ds:X509Data" }

              it "exists" do
                expect(node).not_to be_nil
              end

              describe "ds:X509Certificate" do
                let(:xpath) { super() + "/ds:X509Certificate" }

                it "exists" do
                  expect(node).not_to be_nil
                end

                it "contains the certificate" do
                  expect(node.text).to eq "certificate-der"
                end
              end
            end
          end
        end
      end
    end
  end
end
