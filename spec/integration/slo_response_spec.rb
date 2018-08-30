# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Validation of Spid::Slo::Response" do
  subject(:slo_response) do
    Spid::Slo::Response.new(
      body: spid_response,
      session_index: session_index,
      request_uuid: request_id
    )
  end

  let(:spid_response) do
    File.read(generate_fixture_path("slo-response.base64"))
  end

  let(:request_id) { "_21df91a89767879fc0f7df6a1490c6000c81644d" }

  let(:idp_metadata_dir_path) { generate_fixture_path("config/idp_metadata") }
  let(:private_key_path) { generate_fixture_path("private-key.pem") }
  let(:certificate_path) { generate_fixture_path("certificate.pem") }

  let(:host) { "https://service.provider" }
  let(:session_index) { "a-session-index" }

  let(:slo_path) { "/spid/slo" }

  before do
    Spid.configure do |config|
      config.hostname = host
      config.idp_metadata_dir_path = idp_metadata_dir_path
      config.private_key = File.read(private_key_path)
      config.certificate = File.read(certificate_path)
      config.slo_path = slo_path
      config.attribute_services = [
        { name: "Service 1", fields: [:email] }
      ]
    end
  end

  after do
    Spid.reset_configuration!
  end

  it "requires a body" do
    expect(slo_response.body).to eq spid_response
  end

  it "requires a session_index" do
    expect(slo_response.session_index).to eq session_index
  end

  context "when response conforms to the request" do
    it { is_expected.to be_valid }
  end

  context "when response isn't conform to the request" do
    let(:slo_path) { "/spid/another/slo" }

    it { is_expected.not_to be_valid }

    pending "#errors" do
      it "contains an error" do
        slo_response.valid?

        expect(slo_response.errors).not_to be_empty
      end
    end
  end
end
