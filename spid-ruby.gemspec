lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spid/ruby/version"

Gem::Specification.new do |spec|
  spec.name                  = "spid-ruby"
  spec.version               = Spid::Ruby::VERSION
  spec.authors               = ["David Librera"]
  spec.email                 = ["davidlibrera@gmail.com"]
  spec.homepage              = "https://github.com/italia/spid-ruby"
  spec.summary               = "SPID (https://www.spid.gov.it) integration for ruby"
  spec.license               = "MIT"

  spec.required_ruby_version = ">= 2.3.0"

  spec.files                 = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
