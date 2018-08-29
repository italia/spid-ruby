# frozen_string_literal: true

RSpec.describe Spid::Saml2::LogoutResponseValidator do
  subject(:validator) do
    described_class.new(response: response, settings: settings)
  end

  let(:response) do
    instance_double(
      "Spid::Saml2:LogoutResposne",
      destination: destination
    )
  end

  let(:settings) do
    instance_double(
      "Spid::Saml2::Settings",
      sp_slo_service_url: "https://service.provider/spid/slo"
    )
  end

  let(:destination) { "https://service.provider/spid/slo" }

  it { is_expected.to be_a described_class }

  describe "#call" do
    context "when all validation pass" do
      it "returns true" do
        expect(validator.call).to be_truthy
      end
    end

    context "when at least one validation fails" do
      let(:destination) do
        "https://service.provider/spid/another/slo"
      end

      it "returns false" do
        expect(validator.call).to be_falsey
      end
    end
  end

  describe "#destination" do
    context "when destination matches the service provider acs url" do
      it "returns true" do
        expect(validator.destination).to be_truthy
      end
    end

    context "when destination doesn't match the service provider acs url" do
      let(:destination) do
        "https://service.provider/spid/another/slo"
      end

      it "returns false" do
        expect(validator.destination).to be_falsey
      end
    end
  end
end
