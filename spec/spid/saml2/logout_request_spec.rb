# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::LogoutRequest do
  subject(:logout_request) do
    described_class.new(
      uuid: "unique-uuid",
      settings: settings
    )
  end

  let(:settings) do
    instance_double(
      "Spid::Saml2::Settings",
      idp_entity_id: "https://identity.provider"
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
    let(:saml_message) { logout_request.to_saml }

    let(:xml_document) { REXML::Document.new(saml_message) }

    let(:node) { xml_document.elements[xpath] }

    describe "samlp::LogoutRequest" do
      let(:xpath) { "/samlp:LogoutRequest" }

      it "exists" do
        expect(node).not_to be_nil
      end

      {
        "ID" => "_unique-uuid",
        "Version" => "2.0",
        "IssueInstant" => "2018-08-04T00:00:00Z",
        "Destination" => "https://identity.provider"
      }.each do |name, value|
        include_examples "has attribute", name, value
      end
    end
  end
end
