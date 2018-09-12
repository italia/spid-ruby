# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::SPMetadata do
  subject(:sp_metadata) { described_class.new(settings: settings) }

  let(:settings) do
    instance_double(
      "Spid::Saml2::Settings",
      sp_entity_id: "https://service.provider",
      sp_acs_binding: "acs-binding-method",
      sp_acs_url: "https://service.provider/sso",
      sp_slo_service_url: "https://service.provider/slo",
      sp_slo_service_binding: "slo-binding-method",
      x509_certificate_der: "certificate-der",
      sp_attribute_services: [
        { name: "Service 1", fields: [:email] },
        { name: "Service 2", fields: %i[iva_code digital_address] }
      ]
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
        "entityID" => "https://service.provider",
        "ID" => "_2b2ffddc5e96594af802f687a3bb8645"
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

        describe "md:AttributeConsumingService" do
          let(:xpath) { super() + "/md:AttributeConsumingService" }

          it "contains 2 elements" do
            elements = REXML::XPath.match(xml_document, xpath)

            expect(elements.size).to eq 2
          end

          [0, 1].each do |element_index|
            describe "element #{element_index}" do
              let(:xpath) { super() + "[#{element_index + 1}]" }

              it "exists" do
                expect(node).not_to be_nil
              end

              include_examples "has attribute", "index", element_index.to_s
            end
          end
        end

        describe "md:AssertionConsumerService" do
          let(:xpath) { super() + "/md:AssertionConsumerService" }

          it "exists" do
            expect(node).not_to be_nil
          end

          {
            "Binding" => "acs-binding-method",
            "Location" => "https://service.provider/sso",
            "index" => "0",
            "isDefault" => "true"
          }.each do |name, value|
            include_examples "has attribute", name, value
          end
        end

        describe "md:SingleLogoutService" do
          let(:xpath) { super() + "/md:SingleLogoutService" }

          it "exists" do
            expect(node).not_to be_nil
          end

          {
            "Binding" => "slo-binding-method",
            "Location" => "https://service.provider/slo"
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
