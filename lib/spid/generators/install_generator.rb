# frozen_string_literal: true

module Spid
  module Generators
    class InstallGenerator < ::Rails::Generators::Base # :nodoc:
      source_root File.expand_path("templates", __dir__)

      def code_that_runs
        copy_file "spid.rb", "config/initializers/spid.rb"
      end
    end
  end
end
