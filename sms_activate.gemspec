# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sms_activate/version'

Gem::Specification.new do |spec|
  spec.name          = 'sms_activate'
  spec.version       = SmsActivate::VERSION
  spec.authors       = ['Vlad Faust']
  spec.email         = ['vladislav.faust@gmail.com']

  spec.summary       = 'sms-activate.ru Ruby API wrapper'
  spec.homepage      = 'http://github.com/vladfaust/sms-activate'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake',    '~> 10.0'
end
