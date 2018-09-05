# frozen_string_literal: true

require "spid/synchronize_idp_metadata"

namespace :spid do
  desc "Synchronize IDP metadata"
  task :fetch_idp_metadata do
    Rake::Task["environment"].invoke if defined?(Rails)
    Spid::SynchronizeIdpMetadata.new.call
  end
end
