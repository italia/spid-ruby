# frozen_string_literal: true

module GenerateFixturePath
  def generate_fixture_path(filepath)
    File.join(
      File.expand_path(__dir__),
      "../",
      "fixtures",
      filepath
    )
  end
end

RSpec.configure do |config|
  config.include GenerateFixturePath
end
