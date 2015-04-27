# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/irkit/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-irkit"
  spec.version       = Ruboty::IRKit::VERSION
  spec.authors       = ["kei-s"]
  spec.email         = ["kei.shiratsuchi@gmail.com"]

  spec.summary       = %q{A ruboty handler to controll IRKit}
  spec.homepage      = "https://github.com/kei-s/ruboty-irkit"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ruboty"
  spec.add_dependency "irkit"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
