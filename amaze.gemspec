# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amaze/version'

Gem::Specification.new do |spec|
  spec.name          = "amaze"
  spec.version       = Amaze::VERSION
  spec.authors       = ["Patrick Marchi"]
  spec.email         = ["mail@patrickmarchi.ch"]

  spec.summary       = %q{Maze generator}
  spec.description   = %q{A maze generator inspired by the book of Jamis Buck, Mazes for Programmers: Code Your Own Twisty Little Passages.}
  spec.homepage      = "https://github.com/pmarchi/amaze"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "chunky_png"
  spec.add_dependency "rainbow"
  spec.add_dependency "gradient"
  spec.add_dependency "rmagick"
end
