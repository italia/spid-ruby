# frozen_string_literal: true

require "spid/synchronize_idp_metadata"

namespace :spid do
  desc "Synchronize IDP metadata"
  task :sync do
    Spid::SynchronizeIdpMetadata.new.call
  end
end
