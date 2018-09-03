# frozen_string_literal: true

module Spid
  class Railtie < ::Rails::Railtie # :nodoc:
    rake_tasks do |_app|
      load "spid/tasks/sync.rake"
    end
  end
end
