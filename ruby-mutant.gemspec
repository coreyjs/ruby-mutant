
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruby-mutant/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby-mutant"
  spec.version       = Mutant::VERSION
  spec.authors       = ["Corey Schaf"]
  spec.email         = ["cschaf@gmail.com"]

  spec.summary       = %q{Clean up your code by encapsulating business logic in mutations!}
  spec.description   = %q{Object mutations that encapsulate business logic.
            RubyMutant makes it simple to add complex logic to objects, in with automatic validation and execution.}
  spec.homepage      = "https://github.com/coreyjs/ruby-mutant"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/coreyjs/ruby-mutant"
    spec.metadata["changelog_uri"] = "https://github.com/coreyjs/ruby-mutant"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
