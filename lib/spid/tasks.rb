# frozen_string_literal: true

require "rake"

["fetch_idp_metadata", "certificate"].each do |task|
  load "spid/tasks/#{task}.rake"
end
