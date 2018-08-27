# frozen_string_literal: true

RSpec.describe "Spid::Metadata conforms to SPID specification" do
  let(:metadata) { Spid::Metadata.new }

  let(:sp_entity_id) { "https://service.provider" }

  let(:assertion_consumer_service_url) { "#{sp_entity_id}/spid/sso" }
  let(:single_logout_service_url) { "#{sp_entity_id}/spid/slo" }

  let(:attribute_services) { [] }
  let(:private_key_path) { generate_fixture_path("private-key.pem") }
  let(:certificate_path) { generate_fixture_path("certificate.pem") }

  before do
    Spid.configure do |config|
      config.hostname = sp_entity_id
      config.acs_path = "/spid/sso"
      config.slo_path = "/spid/slo"
      config.attribute_services = attribute_services
      config.private_key = File.read(private_key_path)
      config.certificate = File.read(certificate_path)
      config.attribute_services = [
        { name: "Service 1", fields: [:email] }
      ]
    end
  end

  describe "#to_xml" do
    let(:xml_document) { metadata.to_xml }

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
        expect(entity_descriptor_node).not_to eq nil
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
          expect(signature_node).to be_nil
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
            expect(key_descriptor_node).not_to eq nil
          end
        end

        describe "SingleLogoutService node" do
          let(:single_logout_service_node) do
            sp_sso_descriptor_node.children.find do |child|
              child.name == "SingleLogoutService"
            end
          end

          let(:attributes) { single_logout_service_node.attributes }

          it "exists" do
            expect(single_logout_service_node).not_to eq nil
          end

          it "contains attribute Binding" do
            attribute = attributes["Binding"].value
            expect(attribute).
              to eq "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
          end

          it "contains attribute Location" do
            attribute = attributes["Location"].value
            expect(attribute).to eq single_logout_service_url
          end

          pending "Provide HTTP-POST binding"
        end

        describe "AssertionConsumerService node" do
          let(:assertion_consumer_service_node) do
            sp_sso_descriptor_node.children.find do |child|
              child.name == "AssertionConsumerService"
            end
          end

          let(:attributes) { assertion_consumer_service_node.attributes }

          it "exists" do
            expect(assertion_consumer_service_node).not_to eq nil
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

      pending "Could contain Organization node"
    end
  end
end
