lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pieces/version'

Gem::Specification.new do |spec|
  spec.name          = 'pieces'
  spec.version       = Pieces::VERSION
  spec.authors       = ['Luke Morton']
  spec.email         = ['lukemorton.dev@gmail.com']

  spec.summary       = %q{Component based static site builder}
  spec.homepage      = 'https://github.com/drpheltright/pieces'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ['pieces']
  spec.require_paths = ['lib']

  spec.add_dependency 'mustache'
  spec.add_dependency 'tilt', '~> 2.0.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
