# frozen_string_literal: true

RSpec.describe Spid::Metadata do
  subject { described_class.new metadata_options }

  let(:metadata_options) do
    {
      issuer: sp_entity_id,
      private_key_filepath: generate_fixture_path("private-key.pem"),
      certificate_filepath: generate_fixture_path("certificate.pem")
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
      end
    end
  end
end
