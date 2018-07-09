# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::SsoResponse do
  subject { described_class.new }

  it { is_expected.to be_a described_class }
end
