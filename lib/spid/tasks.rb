# frozen_string_literal: true

require "rake"

["sync", "certificate"].each do |task|
  load "spid/tasks/#{task}.rake"
end
