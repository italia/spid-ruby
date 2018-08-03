# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Spid::Sso::Request conforms SPID specification" do
  let(:sso_request) do
    Spid::Sso::Request.new(
      idp_name: idp_name,
      relay_state: relay_state,
      authn_context: authn_context
    )
  end

  let(:idp_name) { "identity-provider" }

  let(:authn_context) { Spid::L1 }

  let(:idp_metadata_dir_path) { generate_fixture_path("config/idp_metadata") }
  let(:private_key_path) { generate_fixture_path("private-key.pem") }
  let(:certificate_path) { generate_fixture_path("certificate.pem") }

  let(:idp_sso_target_url) { "https://identity.provider/sso" }
  let(:protocol_binding) { "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" }
  let(:sp_sso_target_url) { "#{sp_entity_id}/spid/sso" }
  let(:sp_entity_id) { "https://service.provider" }
  let(:digest_method) { Spid::SHA256 }
  let(:signature_method) { Spid::RSA_SHA256 }
  let(:relay_state) { "/path/to/return" }

  before do
    Spid.configure do |config|
      config.hostname = "https://service.provider"
      config.idp_metadata_dir_path = idp_metadata_dir_path
      config.private_key = File.read(private_key_path)
      config.certificate = File.read(certificate_path)
    end
    Timecop.freeze
  end

  after do
    Timecop.return
    Spid.reset_configuration!
  end

  describe "#url" do
    let(:saml_url) { sso_request.url }

    let(:xml_document) { parse_saml_request_from_url(saml_url) }

    let(:document_node) do
      Nokogiri::XML(
        xml_document.to_s
      )
    end

    describe "AuthnRequest node" do
      let(:authn_request_node) do
        document_node.children.find do |child|
          child.name == "AuthnRequest"
        end
      end

      let(:attributes) { authn_request_node.attributes }

      it "exists" do
        expect(authn_request_node).not_to eq nil
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
        expect(attributes["Destination"].value).to eq idp_sso_target_url
      end

      describe "Signature node" do
        let(:signature_node) do
          authn_request_node.children.find do |child|
            child.name == "Signature"
          end
        end

        it "doesn't exists" do
          expect(signature_node).to eq nil
        end
      end

      describe "attribute ForceAuthn" do
        let(:attribute) { attributes["ForceAuthn"] }

        context "when authn_context is #{Spid::L1}" do
          it "doesn't exist" do
            expect(attribute).to be_nil
          end
        end

        [
          Spid::L2,
          Spid::L3
        ].each do |authn_context_value|
          context "when authn_context is #{authn_context_value}" do
            let(:authn_context) { authn_context_value }

            it "exists" do
              expect(attribute).not_to eq nil
            end
          end
        end
      end

      it "contains attribute AssertionConsumerServiceURL" do
        attribute = attributes["AssertionConsumerServiceURL"].value
        expect(attribute).to eq sp_sso_target_url
      end

      it "contains attribute ProtocolBinding" do
        attribute = attributes["ProtocolBinding"].value
        expect(attribute).to eq protocol_binding
      end

      xit "contains attribute AttributeConsumingServiceIndex"

      describe "Issuer node" do
        let(:issuer_node) do
          authn_request_node.children.find do |child|
            child.name == "Issuer"
          end
        end

        let(:attributes) { issuer_node.attributes }

        it "exists" do
          expect(issuer_node).not_to eq nil
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

      describe "NameIDPolicy node" do
        let(:name_id_policy_node) do
          authn_request_node.children.find do |child|
            child.name == "NameIDPolicy"
          end
        end

        let(:attributes) { name_id_policy_node.attributes }

        it "exists" do
          expect(name_id_policy_node).not_to eq nil
        end

        it "doesn't contain the AllowCreate attribute" do
          attribute = attributes["AllowCreate"]
          expect(attribute).to eq nil
        end

        it "contains attribute Format" do
          attribute = attributes["Format"].value
          expect(attribute).
            to eq "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
        end
      end

      describe "Conditions node" do
        let(:name_id_policy_node) do
          authn_request_node.children.find do |child|
            child.name == "NameIDPolicy"
          end
        end

        xit "exists"
      end

      describe "RequestedAuthnContext node" do
        let(:requested_authn_context) do
          authn_request_node.children.find do |child|
            child.name == "RequestedAuthnContext"
          end
        end

        let(:attributes) { requested_authn_context.attributes }

        it "exists" do
          expect(requested_authn_context).not_to eq nil
        end

        describe "AuthnContextClassRef node" do
          let(:authn_context_class_ref_node) do
            requested_authn_context.children.find do |child|
              child.name == "AuthnContextClassRef"
            end
          end

          context "when authn_context is not provided" do
            it "contains SPIDL1 class" do
              expect(authn_context_class_ref_node.text).to eq Spid::L1
            end
          end

          [
            Spid::L1,
            Spid::L2,
            Spid::L3
          ].each do |authn_context_value|
            context "when provided authn_context is #{authn_context_value}" do
              let(:authn_context) { authn_context_value }

              it "contains that level" do
                expect(authn_context_class_ref_node.text).to eq authn_context
              end
            end
          end

          context "when provided authn_context is none of the expected" do
            let(:authn_context) { "another_authn_level" }

            it "raises an exception" do
              expect { xml_document }.
                to raise_error Spid::UnknownAuthnContextError
            end
          end
        end
      end
    end
  end
end
