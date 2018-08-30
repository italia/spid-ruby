# frozen_string_literal: true

RSpec.describe Spid::Saml2::LogoutResponseValidator do
  subject(:validator) do
    described_class.new(
      response: response,
      settings: settings,
      request_uuid: ""
    )
  end

  let(:response) do
    instance_double(
      "Spid::Saml2:LogoutResponse",
      destination: destination,
      issuer: issuer,
      in_response_to: ""
    )
  end

  let(:issuer) { "https://identity.provider" }

  let(:settings) do
    instance_double(
      "Spid::Saml2::Settings",
      sp_slo_service_url: "https://service.provider/spid/slo",
      idp_entity_id: "https://identity.provider"
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

  describe "#issuer" do
    context "when response issuer match setted issuer" do
      it "returns true" do
        expect(validator.issuer).to be_truthy
      end
    end

    context "when response issuer doesn't match setted issuer" do
      let(:issuer) { "https://another-identity.provider" }

      it "returns false" do
        expect(validator.issuer).to be_falsey
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
