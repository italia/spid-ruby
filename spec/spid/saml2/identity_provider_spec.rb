# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::IdentityProvider do
  subject(:idp_configuration) do
    described_class.new(metadata: metadata)
  end

  let(:metadata) do
    File.read(metadata_file_path)
  end

  let(:metadata_file_path) do
    generate_fixture_path("config/idp_metadata/identity-provider-metadata.xml")
  end

  let(:certificate_pem) do
    File.read(generate_fixture_path("idp-certificate.pem"))
  end

  let(:certificate) do
    OpenSSL::X509::Certificate.new(certificate_pem)
  end

  it { is_expected.to be_a described_class }

  it "requires an entity_id" do
    expect(idp_configuration.entity_id).to eq "https://identity.provider"
  end

  it "requires an sso_target_url" do
    expect(idp_configuration.sso_target_url).
      to eq "https://identity.provider/sso"
  end

  it "requires an slo_target_url" do
    expect(idp_configuration.slo_target_url).
      to eq "https://identity.provider/slo"
  end

  it "requires a certificate" do
    expect(idp_configuration.certificate.to_der).to eq certificate.to_der
  end
end
