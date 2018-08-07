# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Sso::Settings do
  subject(:sso_settings) do
    described_class.new(sso_attributes.merge(optional_sso_attributes))
  end

  let(:sso_attributes) do
    {
      service_provider: service_provider,
      identity_provider: identity_provider
    }
  end

  let(:optional_sso_attributes) { {} }

  let(:identity_provider) do
    instance_double(
      "Spid::Saml2::IdentityProvider",
      sso_attributes: {
        idp_sso_target_url: "https://identity.provider/sso",
        idp_cert_fingerprint: "certificate-fingerprint"
      }
    )
  end

  let(:service_provider) do
    instance_double(
      "Spid::Saml2::ServiceProvider",
      sso_attributes: {
        assertion_consumer_service_url: "https://service.provider/sso",
        issuer: "https://service.provider",
        private_key: "a-private-key",
        certificate: "a-certificate",
        security: {
          authn_requests_signed: true,
          embed_sign: true,
          digest_method: "a-digest-method",
          signature_method: "a-signature-method"
        }
      }
    )
  end

  it { is_expected.to be_a described_class }

  it "requires a service provider configuration" do
    expect(sso_settings.service_provider).
      to eq service_provider
  end

  it "requires a identity provider configuration" do
    expect(sso_settings.identity_provider).
      to eq identity_provider
  end

  describe "AuthnContext attribute" do
    context "when authn_context is not provided" do
      it "contains SPIDL1 class" do
        expect(sso_settings.authn_context).to eq Spid::L1
      end
    end

    [
      Spid::L1,
      Spid::L2,
      Spid::L3
    ].each do |authn_context|
      context "when provided authn_context is #{authn_context}" do
        let(:optional_sso_attributes) do
          {
            authn_context: authn_context
          }
        end

        it "contains that class" do
          expect(sso_settings.authn_context).to eq authn_context
        end
      end
    end

    context "when provided authn_context is none of the expected" do
      let(:optional_sso_attributes) do
        {
          authn_context: "another_authn_level"
        }
      end

      it "raises an exception" do
        expect { sso_settings }.
          to raise_error Spid::UnknownAuthnContextError
      end
    end
  end
end
