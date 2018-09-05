# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Spid configuration" do
  before do
    Spid.configure do |config|
      config.hostname = "https://identity.provider"
      config.default_relay_state_path = "/"
      config.metadata_path = "/custom/metadata/path"
      config.logout_path = "/custom/logout/path"
      config.login_path = "/custom/login/path"
      config.acs_path = "/custom/sso/path"
      config.slo_path = "/custom/slo/path"
      config.digest_method = Spid::SHA512
      config.signature_method = Spid::RSA_SHA512
      config.acs_binding = Spid::BINDINGS_HTTP_REDIRECT
      config.slo_binding = Spid::BINDINGS_HTTP_POST
      config.attribute_services = [
        { name: "Service 1 Name", fields: [:fiscal_number] },
        { name: "Service 2 Name", fields: [:email] }
      ]
    end
  end

  after do
    Spid.reset_configuration!
  end

  let(:configuration) do
    Spid.configuration
  end

  {
    hostname: "https://identity.provider",
    default_relay_state_path: "/",
    metadata_path: "/custom/metadata/path",
    login_path: "/custom/login/path",
    logout_path: "/custom/logout/path",
    acs_path: "/custom/sso/path",
    slo_path: "/custom/slo/path",
    digest_method: Spid::SHA512,
    signature_method: Spid::RSA_SHA512,
    acs_binding: Spid::BINDINGS_HTTP_REDIRECT,
    slo_binding: Spid::BINDINGS_HTTP_POST,
    attribute_services: [
      { name: "Service 1 Name", fields: [:fiscal_number] },
      { name: "Service 2 Name", fields: [:email] }
    ]
  }.each do |config_name, value|
    it "configure '#{config_name}" do
      expect(configuration.send(config_name)).to eq value
    end
  end
end
