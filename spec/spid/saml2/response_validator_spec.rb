# frozen_string_literal: true

RSpec.describe Spid::Saml2::ResponseValidator do
  subject(:validator) do
    described_class.new(
      response: response,
      settings: settings
    )
  end

  let(:response) do
    instance_double(
      "Spid::Saml2::Response",
      assertion_issuer: assertion_issuer
    )
  end

  let(:settings) do
    instance_double(
      "Spid::Saml2::Settings",
      idp_entity_id: "https://identity.provider"
    )
  end

  let(:assertion_issuer) do
    "https://identity.provider"
  end

  it { is_expected.to be_a described_class }

  describe "#issuer" do
    context "when response issuer match setted issuer" do
      it "returns true" do
        expect(validator.issuer).to be_truthy
      end
    end

    context "when response issuer doesn't match setted issuer" do
      let(:assertion_issuer) do
        "https://another-identity.provider"
      end

      it "returns false" do
        expect(validator.issuer).to be_falsey
      end
    end
  end
end
