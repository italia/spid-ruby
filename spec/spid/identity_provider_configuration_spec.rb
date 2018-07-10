require "spec_helper"

RSpec.describe Spid::IdentityProviderConfiguration do
  subject { described_class.new }

  it { is_expected.to be_a described_class }
end
