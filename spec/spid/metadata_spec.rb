# frozen_string_literal: true

RSpec.describe Spid::Metadata do
  subject { described_class.new }

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

      it "exists" do
        expect(entity_descriptor_node).to be_present
      end
    end
  end
end
