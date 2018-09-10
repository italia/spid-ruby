# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::Settings do
  subject(:settings) do
    described_class.new(
      authn_context: authn_context,
      identity_provider: identity_provider,
      service_provider: service_provider
    )
  end

  let(:identity_provider) do
    instance_double(
      "Spid::Saml2::IdentityProvider",
      entity_id: "https://identity.provider",
      sso_target_url: "https://identity.provider/sso",
      slo_target_url: "https://identity.provider/slo"
    )
  end

  let(:service_provider) do
    instance_double(
      "Spid::Saml2::ServiceProvider",
      host: "https://service.provider",
      signature_method: Spid::RSA_SHA256,
      private_key: OpenSSL::PKey::RSA.new(private_key),
      certificate: OpenSSL::X509::Certificate.new(certificate),
      acs_url: "acs-url",
      acs_binding: "acs-binding-method",
      slo_url: "slo-url",
      slo_binding: "slo-binding-method"
    )
  end

  let(:private_key) do
    File.read(generate_fixture_path("private-key.pem"))
  end

  let(:certificate) do
    File.read(generate_fixture_path("certificate.pem"))
  end

  let(:der_certificate) do
    File.read(generate_fixture_path("certificate.der.base64"))
  end

  let(:authn_context) { nil }

  context "when valid attributes are provided" do
    it { is_expected.to be_a described_class }
  end

  context "when auth_context value is not valid" do
    let(:authn_context) { "not-valid-attribute" }

    it do
      expect { settings }.to raise_error Spid::UnknownAuthnContextError
    end
  end

  describe "#idp_entity_id" do
    it "returns the identity provider entity id" do
      expect(settings.idp_entity_id).to eq "https://identity.provider"
    end
  end

  describe "#idp_sso_target_url" do
    it "returns the identity provider sso url" do
      expect(settings.idp_sso_target_url).to eq "https://identity.provider/sso"
    end
  end

  describe "#idp_slo_target_url" do
    it "returns the identity provider slo url" do
      expect(settings.idp_slo_target_url).to eq "https://identity.provider/slo"
    end
  end

  describe "#private_key" do
    it "returns the service provider private_key" do
      expect(settings.private_key).to be_an OpenSSL::PKey::RSA
    end
  end

  describe "#signature_method" do
    it "returns the service provider signature_method" do
      expect(settings.signature_method).to eq Spid::RSA_SHA256
    end
  end

  describe "#acs_index" do
    it "returns '0'" do
      expect(settings.acs_index).to eq "0"
    end
  end

  describe "#sp_entity_id" do
    it "returns the service provider entity id" do
      expect(settings.sp_entity_id).to eq "https://service.provider"
    end
  end

  describe "#sp_acs_url" do
    it "returns the service provider acs url" do
      expect(settings.sp_acs_url).to eq "acs-url"
    end
  end

  describe "#sp_acs_binding" do
    it "returns the service provider acs binding method" do
      expect(settings.sp_acs_binding).to eq "acs-binding-method"
    end
  end

  describe "#sp_slo_service_url" do
    it "returns the service provider slo url" do
      expect(settings.sp_slo_service_url).to eq "slo-url"
    end
  end

  describe "#sp_slo_service_binding" do
    it "returns the service provider slo binding method" do
      expect(settings.sp_slo_service_binding).to eq "slo-binding-method"
    end
  end

  describe "x509_certificate_der" do
    it "returns the certificate in der format in base64 encoding" do
      expect(settings.x509_certificate_der).
        to eq der_certificate
    end
  end

  describe "#force_authn?" do
    context "when authn_context is '#{Spid::L1}'" do
      let(:authn_context) { Spid::L1 }

      it "returns true" do
        expect(settings).not_to be_force_authn
      end
    end

    [
      Spid::L2,
      Spid::L3
    ].each do |valid_authn_context|
      context "when authn_context is '#{valid_authn_context}'" do
        let(:authn_context) { valid_authn_context }

        it "returns true" do
          expect(settings).to be_force_authn
        end
      end
    end
  end

  describe "#authn_context" do
    context "when attribute is not provided" do
      it "returns the default authn_context" do
        expect(settings.authn_context).to eq Spid::L1
      end
    end

    [
      Spid::L1,
      Spid::L2,
      Spid::L3
    ].each do |valid_authn_context|
      context "when attribute '#{valid_authn_context}' is provided" do
        let(:authn_context) { valid_authn_context }

        it "returns provider authn_context" do
          expect(settings.authn_context).to eq valid_authn_context
        end
      end
    end
  end
end
