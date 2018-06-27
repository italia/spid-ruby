# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"
RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ["--display-cop-names"]
end

require "bundler/audit/task"
Bundler::Audit::Task.new

task default: :spec
task default: :rubocop
task default: "bundle:audit"
