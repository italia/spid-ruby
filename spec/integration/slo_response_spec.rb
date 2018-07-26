# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Validation of Spid::Slo::Response" do
  subject(:slo_response) do
    Spid::Slo::Response.new(
      body: spid_response,
      session_index: session_index,
      matches_request_id: request_id
    )
  end

  let(:spid_response) do
    File.read(generate_fixture_path("slo-response.base64"))
  end

  let(:request_id) { "_21df91a89767879fc0f7df6a1490c6000c81644d" }

  let(:idp_metadata_dir_path) { generate_fixture_path("config/idp_metadata") }
  let(:private_key_path) { generate_fixture_path("private-key.pem") }
  let(:certificate_path) { generate_fixture_path("certificate.pem") }

  let(:cert_fingerprint) do
    "C6:82:11:E5:44:22:53:58:05:B2:3F:2D:24:52:8B:17:95:C3:62:89"
  end

  let(:host) { "https://service.provider" }
  let(:session_index) { "a-session-index" }

  let(:idp_metadata) do
    File.read(generate_fixture_path("identity-provider-metadata.xml"))
  end

  before do
    Spid.configure do |config|
      config.hostname = host
      config.idp_metadata_dir_path = idp_metadata_dir_path
      config.private_key = File.read(private_key_path)
      config.certificate = File.read(certificate_path)
    end
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
    let(:request_id) { "not-valid-request-id" }

    it { is_expected.not_to be_valid }
  end
end
