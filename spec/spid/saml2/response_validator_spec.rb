# frozen_string_literal: true

RSpec.describe Spid::Saml2::ResponseValidator do
  subject(:validator) do
    described_class.new(
      response: response,
      settings: settings,
      request_uuid: request_uuid
    )
  end

  let(:response) do
    instance_double(
      "Spid::Saml2::Response",
      issuer: issuer,
      assertion_issuer: assertion_issuer,
      destination: destination,
      conditions_not_before: "2018-01-01T00:00:00Z",
      conditions_not_on_or_after: "2018-02-01T00:00:00Z",
      saml_message: signed_response,
      certificate: response_certificate,
      status_code: status_code,
      status_message: status_message,
      status_detail: status_detail,
      audience: audience,
      in_response_to: in_response_to,
      subject_recipient: subject_recipient,
      subject_in_response_to: subject_in_response_to,
      subject_not_on_or_after: "2018-02-01T00:00:00Z"
    )
  end

  let(:request_uuid) { "a-request-uuid" }

  let(:signed_response) do
    File.read(generate_fixture_path("sso-response/signed.xml"))
  end

  let(:response_certificate_pem) do
    File.read(generate_fixture_path("idp-certificate.pem"))
  end

  let(:response_certificate) do
    OpenSSL::X509::Certificate.new(response_certificate_pem)
  end

  let(:status_code) { Spid::SUCCESS_CODE }

  let(:status_message) { "Status message" }
  let(:status_detail) { "Status_Details" }

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

  let(:issuer) { "https://identity.provider" }

  let(:assertion_issuer) { "https://identity.provider" }

  let(:destination) { "https://service.provider/spid/sso" }

  let(:audience) { "https://service.provider" }

  let(:local_time) { Time.gm(2018, 1, 10) }

  let(:in_response_to) { "a-request-uuid" }

  let(:subject_recipient) { "https://service.provider/spid/sso" }

  let(:subject_in_response_to) { "a-request-uuid" }

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

      it "has errors" do
        validator.call
        expect(validator.errors.keys).to be_any
      end
    end
  end

  describe "#matches_request_uuid" do
    context "when request uuid matches" do
      it "returns true" do
        expect(validator.matches_request_uuid).to be_truthy
      end
    end

    context "when request uuid doesn't match" do
      let(:request_uuid) { "failing-code" }

      it "returns false" do
        expect(validator.matches_request_uuid).to be_falsey
      end

      it "has errors" do
        validator.call
        expect(validator.errors.keys).to include "request_uuid_mismatch"
      end
    end
  end

  describe "#success?" do
    context "when status code is success" do
      it "returns true" do
        expect(validator).to be_success
      end
    end

    context "when status code is not success" do
      let(:status_code) { "failing-code" }

      it "returns false" do
        expect(validator.call).to be_falsey
      end

      it "has errors" do
        validator.call
        expect(validator.errors.keys).to be_any
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

      it "has errors" do
        validator.issuer
        expect(validator.errors.keys).to include "issuer"
      end
    end
  end

  describe "#assertion_issuer" do
    context "when response issuer match setted issuer" do
      it "returns true" do
        expect(validator.assertion_issuer).to be_truthy
      end
    end

    context "when response issuer doesn't match setted issuer" do
      let(:assertion_issuer) { "https://another-identity.provider" }

      it "returns false" do
        expect(validator.assertion_issuer).to be_falsey
      end

      it "has errors" do
        validator.assertion_issuer
        expect(validator.errors.keys).to include "assertion_issuer"
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

      it "has errors" do
        validator.destination
        expect(validator.errors.keys).to include "destination"
      end
    end
  end

  describe "#conditions" do
    context "when response is received in the right time window" do
      it "returns true" do
        expect(validator.conditions).to be_truthy
      end
    end

    context "when response is received before the time window" do
      let(:local_time) { Time.gm(2017, 12, 31) }

      it "returns false" do
        expect(validator.conditions).to be_falsey
      end

      it "has errors" do
        validator.conditions
        expect(validator.errors.keys).to include "conditions"
      end
    end

    context "when response is received after the time window" do
      let(:local_time) { Time.gm(2018, 2, 1) }

      it "returns false" do
        expect(validator.conditions).to be_falsey
      end

      it "has errors" do
        validator.conditions
        expect(validator.errors.keys).to include "conditions"
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

      it "has errors" do
        validator.audience
        expect(validator.errors.keys).to include "audience"
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

      it "has errors" do
        validator.signature
        expect(validator.errors.keys).to include "signature"
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

  describe "#subject_recipient" do
    context "when the response contains the assertion consuming service url" do
      it "returns true" do
        expect(validator.subject_recipient).to be_truthy
      end
    end

    context "when the response contains a different value" do
      let(:subject_recipient) do
        "another-value"
      end

      it "returns false" do
        expect(validator.subject_recipient).to be_falsey
      end
    end
  end

  describe "#subject_in_response_to" do
    context "when the response contains request uuid" do
      it "returns true" do
        expect(validator.subject_in_response_to).to be_truthy
      end
    end

    context "when the response contains a different value" do
      let(:subject_in_response_to) { "another-value" }

      it "returns false" do
        expect(validator.subject_in_response_to).to be_falsey
      end
    end
  end

  describe "#subject_not_on_or_after" do
    context "when the response is received before that time value" do
      it "returns true" do
        expect(validator.subject_not_on_or_after).to be_truthy
      end
    end

    context "when the response contains a different value" do
      let(:local_time) { Time.gm(2018, 2, 1) }

      it "returns false" do
        expect(validator.subject_not_on_or_after).to be_falsey
      end
    end
  end
end
