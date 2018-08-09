# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::LogoutRequest do
  subject(:logout_request) do
    described_class.new
  end

  it { is_expected.to be_a described_class }

  describe "#to_saml" do
    let(:saml_message) { logout_request.to_saml }

    let(:xml_document) { REXML::Document.new(saml_message) }

    let(:node) { xml_document.elements[xpath] }

    describe "samlp::LogoutRequest" do
      let(:xpath) { "/samlp:LogoutRequest" }

      it "exists" do
        expect(node).not_to be_nil
      end
    end
  end
end
