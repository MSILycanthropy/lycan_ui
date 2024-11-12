# frozen_string_literal: true

require_relative "lib/lycan_ui/version"

Gem::Specification.new do |spec|
  spec.name        = "lycan_ui"
  spec.version     = LycanUi::VERSION
  spec.authors     = [ "Ethan Kircher" ]
  spec.email       = [ "ethanmichaelk@gmail.com" ]
  spec.homepage    = "https://github.com/MSILycanthropy/lycan_ui"
  spec.summary     = "View Component based UI framework for Rails."
  spec.description = spec.summary
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency("rails", ">= 7.1.3")
end
