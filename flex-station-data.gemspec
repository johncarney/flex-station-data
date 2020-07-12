lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "flex_station_data/version"

Gem::Specification.new do |spec|
  spec.name          = "flex-station-data"
  spec.version       = FlexStationData::VERSION
  spec.authors       = ["John Carney"]
  spec.email         = ["john@carney.id.au"]

  spec.summary       = %q{Data analysis tool for FlexStation microplate reader}
  spec.description   = %q{Data analysis tool for FlexStation microplate reader}
  spec.homepage      = "https://github.com/johncarney/flex-station-data"
  spec.license       = "MIT"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = "https://github.com/johncarney/flex-station-data"
  spec.metadata["source_code_uri"] = "https://github.com/johncarney/flex-station-data"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7.1"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "linefit"
end
