# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::SPMetadata do
  subject(:sp_metadata) do
    described_class.new(settings: settings)
  end

  let(:settings) do
    instance_double(
      "Spid::Saml2::Settings",
      sp_entity_id: "https://service.provider"
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

      include_examples "has attribute", "EntityID", "https://service.provider"
    end
  end
end
