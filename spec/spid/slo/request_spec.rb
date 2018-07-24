# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Slo::Request do
  subject(:sso_request) { described_class.new(slo_settings: slo_settings) }

  let(:slo_settings) do
    Spid::Slo::Settings.new(slo_settings_attributes)
  end

  let(:slo_settings_attributes) do
    {
      service_provider_configuration: service_provider_configuration,
      identity_provider_configuration: identity_provider_configuration,
      session_index: session_index
    }
  end

  let(:service_provider_configuration) do
    instance_double(
      "Spid::ServiceProviderConfiguration",
      slo_attributes: {
        issuer: sp_entity_id,
        private_key: File.read(generate_fixture_path("private-key.pem")),
        certificate: File.read(generate_fixture_path("certificate.pem")),
        security: {
          logout_requests_signed: true,
          embed_sign: true,
          digest_method: digest_method,
          signature_method: signature_method
        }
      }
    )
  end

  let(:identity_provider_configuration) do
    instance_double(
      "Spid::IdentityProviderConfiguration",
      slo_attributes: {
        idp_slo_target_url: idp_slo_target_url,
        idp_name_qualifier: idp_entity_id,
        idp_cert_fingerprint: "certificate-fingerprint"
      }
    )
  end

  let(:idp_slo_target_url) { "https://identity.provider/slo" }
  let(:sp_entity_id) { "https://service.provider" }
  let(:idp_entity_id) { "https://identity.provider" }
  let(:session_index) { "session-index-value" }
  let(:digest_method) { Spid::SHA256 }
  let(:signature_method) { Spid::RSA_SHA256 }

  it { is_expected.to be_a described_class }

  describe "#to_saml" do
    before { Timecop.freeze }

    after { Timecop.return }

    let(:saml_url) { subject.to_saml }

    let(:xml_document) { parse_saml_request_from_url(saml_url) }

    let(:document_node) do
      Nokogiri::XML(
        xml_document.to_s
      )
    end

    describe "LogoutRequest node" do
      let(:logout_request_node) do
        document_node.children.find do |child|
          child.name == "LogoutRequest"
        end
      end

      let(:attributes) { logout_request_node.attributes }

      it "exists" do
        expect(logout_request_node).to be_present
      end

      it "contains attribute ID" do
        regexp = /_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
        expect(attributes["ID"].value).to match regexp
      end

      it "contains attribute Version" do
        expect(attributes["Version"].value).to eq "2.0"
      end

      it "contains attribute IssueInstant" do
        expect(attributes["IssueInstant"].value).to eq Time.now.utc.iso8601
      end

      it "contains attribute Destination" do
        expect(attributes["Destination"].value).to eq idp_slo_target_url
      end

      describe "Issuer node" do
        let(:issuer_node) do
          logout_request_node.children.find do |child|
            child.name == "Issuer"
          end
        end

        let(:attributes) { issuer_node.attributes }

        it "exists" do
          expect(issuer_node).to be_present
        end

        it "contains sp_entity_id" do
          expect(issuer_node.text).to eq sp_entity_id
        end

        it "contains attribute Format" do
          attribute = attributes["Format"].value
          expect(attribute).
            to eq "urn:oasis:names:tc:SAML:2.0:nameid-format:entity"
        end

        it "contains attribute NameQualifier" do
          attribute = attributes["NameQualifier"].value
          expect(attribute).to eq sp_entity_id
        end
      end

      describe "nameID" do
        let(:name_id_node) do
          logout_request_node.children.find do |child|
            child.name == "NameID"
          end
        end

        let(:attributes) { name_id_node.attributes }

        it "exists" do
          expect(name_id_node).to be_present
        end

        it "contains attribute Format" do
          attribute = attributes["Format"].value
          expect(attribute).
            to eq "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
        end

        it "contains attribute NameQualifier" do
          attribute = attributes["NameQualifier"].value
          expect(attribute).to eq idp_entity_id
        end
      end

      describe "SessionIndex node" do
        let(:session_index_node) do
          logout_request_node.children.find do |child|
            child.name == "SessionIndex"
          end
        end

        it "exists" do
          expect(session_index_node).to be_present
        end

        it "contains provided session index" do
          expect(session_index_node.text).to eq session_index
        end
      end

      describe "Signature node" do
        let(:signature_node) do
          logout_request_node.children.find do |child|
            child.name == "Signature"
          end
        end

        it "exists" do
          expect(signature_node).to be_present
        end
      end
    end
  end
end
