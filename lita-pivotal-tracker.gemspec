Gem::Specification.new do |spec|
  spec.name          = "lita-pivotal-tracker"
  spec.version       = "0.0.1"
  spec.authors       = ["Marty Trzpit"]
  spec.email         = ["mtrizzy@gmail.com"]
  spec.description   = %q(Lita handler for adding stories to Pivotal Tracker.)
  spec.summary       = %q(Lita handler for adding stories to Pivotal Tracker.)
  spec.homepage      = "https://github.com/martytrzpit/lita-pivotal-tracker"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 3.2"
  spec.add_runtime_dependency "lita-keyword-arguments"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0.beta2"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
