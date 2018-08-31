# frozen_string_literal: true

RSpec.describe Spid::Saml2::IdpLogoutRequestValidator do
  subject(:validator) do
    described_class.new(request: request)
  end

  let(:request) { nil }

  it { is_expected.to be_a described_class }

  describe "#call" do
    it "returns true" do
      expect(validator.call).to be_truthy
    end
  end
end
