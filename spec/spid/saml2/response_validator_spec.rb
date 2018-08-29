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
      saml_message: signed_response,
      certificate: response_certificate,
      audience: audience
    )
  end

  let(:signed_response) do
    File.read(generate_fixture_path("sso-response-signed.xml"))
  end

  let(:response_certificate_pem) do
    File.read(generate_fixture_path("idp-certificate.pem"))
  end

  let(:response_certificate) do
    OpenSSL::X509::Certificate.new(response_certificate_pem)
  end

  let(:settings) do
    instance_double(
      "Spid::Saml2::Settings",
      idp_entity_id: "https://identity.provider",
      sp_entity_id: "https://service.provider",
      sp_acs_url: "https://service.provider/spid/sso",
      idp_certificate: idp_certificate
    )
  end

  let(:idp_certificate_pem) { response_certificate_pem }
  let(:idp_certificate) do
    OpenSSL::X509::Certificate.new(idp_certificate_pem)
  end

  let(:assertion_issuer) { "https://identity.provider" }

  let(:destination) { "https://service.provider/spid/sso" }

  let(:audience) { "https://service.provider" }

  let(:local_time) { Time.gm(2018, 1, 10) }

  it { is_expected.to be_a described_class }

  before do
    Timecop.freeze(local_time)
  end

  after do
    Timecop.return
  end

  describe "#call" do
    context "when all validation pass" do
      it "returns true" do
        expect(validator.call).to be_truthy
      end
    end

    context "when at least one validation fails" do
      let(:assertion_issuer) { "https://another-identity.provider" }

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
      let(:assertion_issuer) { "https://another-identity.provider" }

      it "returns false" do
        expect(validator.issuer).to be_falsey
      end
    end
  end

  describe "#destination" do
    context "when destination matches the service provider entity id" do
      it "returns true" do
        expect(validator.destination).to be_truthy
      end
    end

    context "when destination doesn't match the service provider acs url" do
      let(:destination) { "https://service.provider/spid/acs" }

      it "returns false" do
        expect(validator.destination).to be_falsey
      end
    end
  end

  describe "#conditions" do
    context "when response is received in the right time window" do
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

  describe "#signature" do
    context "with the correct certificate" do
      it "returns true" do
        expect(validator.signature).to be_truthy
      end
    end

    context "with a different certificate" do
      let(:response_certificate_pem) do
        File.read(generate_fixture_path("certificate.pem"))
      end

      it "returns false" do
        expect(validator.signature).to be_falsey
      end
    end
  end

  describe "#certificate" do
    context "when the response contains the correct certificate" do
      it "returns true" do
        expect(validator.certificate).to be_truthy
      end
    end

    context "when the response contains a different certificate" do
      let(:idp_certificate_pem) do
        File.read(generate_fixture_path("certificate.pem"))
      end

      it "returns false" do
        expect(validator.certificate).to be_falsey
      end
    end
  end
end
