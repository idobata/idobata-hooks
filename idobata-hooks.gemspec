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

  spec.add_dependency 'actionpack', '>= 5.1.0'
  spec.add_dependency 'activesupport', '>= 5.1.0'
  spec.add_dependency 'gemoji'
  spec.add_dependency 'commonmarker'
  spec.add_dependency 'haml'
  spec.add_dependency 'hashie'
  spec.add_dependency 'html-pipeline', '>= 2.6.0'
  spec.add_dependency 'html-pipeline-rouge_filter'
  spec.add_dependency 'mime-types'
  spec.add_dependency 'sass'
  spec.add_dependency 'tilt'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'sinatra'
  spec.add_development_dependency 'sinatra-contrib'
  spec.add_development_dependency 'sprockets'
  spec.add_development_dependency 'tapp'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rack-test'
end
