lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'idobata/hook/version'

Gem::Specification.new do |spec|
  spec.name          = 'idobata-hooks'
  spec.version       = Idobata::Hook::VERSION
  spec.authors       = ['Keita Urashima', 'hibariya', 'Ryunosuke Sato']
  spec.email         = ['hi@idobata.io']
  spec.summary       = %q{A collection of Idobata hooks.}
  spec.description   = %q{A collection of Idobata hooks.}
  spec.homepage      = 'https://github.com/idobata/idobata-hooks'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'actionpack', '~> 5.0.0'
  spec.add_dependency 'activesupport', '~> 5.0.0'
  spec.add_dependency 'gemoji'
  spec.add_dependency 'github-markdown'
  spec.add_dependency 'haml'
  spec.add_dependency 'hashie'
  spec.add_dependency 'html-pipeline'
  spec.add_dependency 'mime-types'
  spec.add_dependency 'pygments.rb'
  spec.add_dependency 'sass'
  spec.add_dependency 'tilt'

  spec.add_development_dependency 'bundler', '~> 1.6'
  # spec.add_development_dependency 'github-linguist' # optional
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'sinatra', '~> 2.0.0.beta'
  spec.add_development_dependency 'sinatra-contrib', '~> 2.0.0.beta'
  spec.add_development_dependency 'sprockets'
  spec.add_development_dependency 'tapp'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rack-test'
end
