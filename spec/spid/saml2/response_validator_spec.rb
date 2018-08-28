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
      assertion_issuer: assertion_issuer,
      destination: destination,
      conditions_not_before: "2018-01-01T00:00:00Z",
      conditions_not_on_or_after: "2018-02-01T00:00:00Z",
      audience: audience
    )
  end

  let(:settings) do
    instance_double(
      "Spid::Saml2::Settings",
      idp_entity_id: "https://identity.provider",
      sp_entity_id: "https://service.provider"
    )
  end

  let(:assertion_issuer) { "https://identity.provider" }

  let(:destination) { "https://service.provider" }

  let(:audience) { "https://service.provider" }

  it { is_expected.to be_a described_class }

  describe "#issuer" do
    context "when response issuer match setted issuer" do
      it "returns true" do
        expect(validator.issuer).to be_truthy
      end
    end

    context "when response issuer doesn't match setted issuer" do
      let(:assertion_issuer) { "https://another-identity.provider" }

      it "returns false" do
        expect(validator.issuer).to be_falsey
      end
    end
  end

  describe "#destination" do
    context "when destination match the service provider entity id" do
      it "returns true" do
        expect(validator.destination).to be_truthy
      end
    end

    context "when destination doesn't match the service provider entity id" do
      let(:destination) { "https://another-service.provider" }

      it "returns false" do
        expect(validator.destination).to be_falsey
      end
    end
  end

  describe "#conditions" do
    before do
      Timecop.freeze(local_time)
    end

    after do
      Timecop.return
    end

    context "when response is received in the right time window" do
      let(:local_time) { Time.gm(2018, 1, 10) }

      it "returns true" do
        expect(validator.conditions).to be_truthy
      end
    end

    context "when response is received after the time window" do
      let(:local_time) { Time.gm(2017, 12, 31) }

      it "returns false" do
        expect(validator.conditions).to be_falsey
      end
    end

    context "when response is received before the time window" do
      let(:local_time) { Time.gm(2018, 2, 1) }

      it "returns false" do
        expect(validator.conditions).to be_falsey
      end
    end
  end

  describe "#audience" do
    context "when conditions audience is the service provider entity id" do
      it "returns true" do
        expect(validator.audience).to be_truthy
      end
    end

    context "when conditions audience is not the service provider entity id" do
      let(:audience) { "https://another-service.provider" }

      it "returns false" do
        expect(validator.audience).to be_falsey
      end
    end
  end
end
