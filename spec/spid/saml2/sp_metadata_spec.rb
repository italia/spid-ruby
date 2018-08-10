# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::SPMetadata do
  subject do
    described_class.new
  end

  it { is_expected.to be_a described_class }
end
