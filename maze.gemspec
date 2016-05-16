# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'maze/version'

Gem::Specification.new do |spec|
  spec.name          = "maze"
  spec.version       = Maze::VERSION
  spec.authors       = ["Patrick Marchi"]
  spec.email         = ["patrick.marchi@geo.uzh.ch"]

  spec.summary       = %q{Maze generator.}
  spec.description   = %q{A maze generator inspired by Mazes for Programmers: Code Your Own Twisty Little Passages
Book by Jamis Buck.}
  spec.homepage      = ""

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "chunky_png"
  spec.add_dependency "oily_png"
  spec.add_dependency "rainbow"
  spec.add_dependency "gradient"
  spec.add_dependency "rmagick"
end
