# frozen_string_literal: true

RSpec.describe Spid::Metadata do
  subject { described_class.new metadata_options }

  let(:metadata_options) do
    {
      issuer: sp_entity_id,
      private_key_filepath: generate_fixture_path("private-key.pem"),
      certificate_filepath: generate_fixture_path("certificate.pem"),
      assertion_consumer_service_url: assertion_consumer_service_url
    }
  end

  let(:private_key_filepath) do
    File.join(
      File.expand_path(__dir__),
      "spec",
      "fixtures",
      "private-key.pem"
    )
  end

  let(:sp_entity_id) { "https://service.provider" }

  let(:assertion_consumer_service_url) { "#{sp_entity_id}/sso" }

  it { is_expected.to be_a described_class }

  describe "#to_xml" do
    let(:xml_document) { subject.to_xml }

    let(:document_node) do
      Nokogiri::XML(
        xml_document.to_s
      )
    end

    describe "EntityDescriptor node" do
      let(:entity_descriptor_node) do
        document_node.children.find do |child|
          child.name == "EntityDescriptor"
        end
      end

      let(:attributes) { entity_descriptor_node.attributes }

      it "exists" do
        expect(entity_descriptor_node).to be_present
      end

      it "contains attribute entityID" do
        attribute = attributes["entityID"].value
        expect(attribute).to eq sp_entity_id
      end

      describe "Signature node" do
        let(:signature_node) do
          entity_descriptor_node.children.find do |child|
            child.name == "Signature"
          end
        end

        it "exists" do
          expect(signature_node).to be_present
        end
      end

      describe "SPSSODescriptor node" do
        let(:sp_sso_descriptor_node) do
          entity_descriptor_node.children.find do |child|
            child.name == "SPSSODescriptor"
          end
        end

        let(:attributes) { sp_sso_descriptor_node.attributes }

        it "contains attribute AuthnRequestsSigned" do
          attribute = attributes["AuthnRequestsSigned"].value
          expect(attribute).to eq "true"
        end

        it "contains attribute protocolSupportEnumeration" do
          attribute = attributes["protocolSupportEnumeration"].value
          expect(attribute).to eq "urn:oasis:names:tc:SAML:2.0:protocol"
        end

        describe "KeyDescriptor node" do
          let(:key_descriptor_node) do
            sp_sso_descriptor_node.children.find do |child|
              child.name == "KeyDescriptor"
            end
          end

          it "exists" do
            expect(key_descriptor_node).to be_present
          end
        end

        describe "AssertionConsumerService node" do
          let(:assertion_consumer_service_node) do
            sp_sso_descriptor_node.children.find do |child|
              child.name == "AssertionConsumerService"
            end
          end

          let(:attributes) { assertion_consumer_service_node.attributes }

          it "exists" do
            expect(assertion_consumer_service_node).to be_present
          end

          it "contains attribute index" do
            attribute = attributes["index"].value
            expect(attribute).to eq "0"
          end

          it "contains attribute isDefault" do
            attribute = attributes["isDefault"].value
            expect(attribute).to eq "true"
          end

          it "contains attribute Binding" do
            attribute = attributes["Binding"].value
            expect(attribute).
              to eq "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
          end

          it "contains attribute Location" do
            attribute = attributes["Location"].value
            expect(attribute).to eq assertion_consumer_service_url
          end
        end
      end
    end
  end
end
