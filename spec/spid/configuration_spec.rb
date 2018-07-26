# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Configuration do
  subject(:config) { described_class.new }

  describe "#idp_metadata_dir_path" do
    it "has a default value" do
      expect(config.idp_metadata_dir_path).to eq "idp_metadata"
    end
  end

  describe "#hostname" do
    it "has not a default value" do
      expect(config.hostname).to eq nil
    end
  end

  describe "#metadata_path" do
    it "has a default value" do
      expect(config.metadata_path).to eq "/spid/metadata"
    end
  end

  describe "#start_sso_path" do
    it "has a default value" do
      expect(config.start_sso_path).to eq "/spid/login"
    end
  end

  describe "#acs_endpoint" do
    it "has a default value" do
      expect(config.acs_endpoint).to eq "/spid/sso"
    end
  end

  describe "#start_slo_path" do
    it "has a default value" do
      expect(config.start_slo_path).to eq "/spid/logout"
    end
  end

  describe "#slo_endpoint" do
    it "has a default value" do
      expect(config.slo_endpoint).to eq "/spid/slo"
    end
  end

  describe "#digest_method" do
    it "has a default value" do
      expect(config.digest_method).to eq Spid::SHA256
    end
  end

  describe "#signature_method" do
    it "has a default value" do
      expect(config.signature_method).to eq Spid::RSA_SHA256
    end
  end

  describe "#private_key" do
    it "has not a default value" do
      expect(config.private_key).to eq nil
    end
  end

  describe "#certificate" do
    it "has a default value" do
      expect(config.certificate).to eq nil
    end
  end
end
