# frozen_string_literal: true

require "rake"

["sync"].each do |task|
  load "spid/tasks/#{task}.rake"
end
