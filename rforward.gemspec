
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rforward/version"

Gem::Specification.new do |spec|
  spec.name          = "rforward"
  spec.version       = Rforward::VERSION
  spec.authors       = ["gingray"]
  spec.email         = ["gingray.dev@gmail.com"]

  spec.summary       = %q{Deliver logs in json format into fluentd}
  spec.description   = %q{ Deliver logs in json format into fluentd through forward plugin }
  spec.homepage      = "https://github.com/gingray/rforward"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_dependency "thor", "~> 0.20"
  spec.add_dependency "fluent-logger"
  spec.add_dependency "dry-container"
  spec.add_dependency "elasticsearch"
end
