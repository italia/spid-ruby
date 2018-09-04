# frozen_string_literal: true

require "spid/generators"

module Spid
  class Railtie < ::Rails::Railtie # :nodoc:
    rake_tasks do |_app|
      require "spid/tasks"
    end
  end
end
