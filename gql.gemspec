# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gql/version"

Gem::Specification.new do |spec|
  spec.name          = "gql"
  spec.version       = Gql::VERSION
  spec.authors       = ["raykin"]
  spec.email         = ["raykincoldxiao@gmail.com"]

  spec.summary       = %q{Graphql in ruby}
  spec.description   = %q{Graphql server in ruby}
  spec.homepage      = "https://github.com/raykin/gql"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "> 4.0"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rley"
  spec.add_development_dependency "pry"
end
