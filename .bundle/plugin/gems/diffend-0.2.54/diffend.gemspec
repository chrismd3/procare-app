# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'diffend/version'

files_locations = %w[
  *.md
  lib/**/*.rb
  config/*
  certs/*
  diffend.gemspec
  plugins.rb
]

Gem::Specification.new do |spec|
  spec.name          = 'diffend'
  spec.version       = Diffend::VERSION
  spec.authors       = ['Tomasz Pajor', 'Maciej Mensfeld']
  spec.email         = ['contact@diffend.io']

  spec.summary       = 'OSS supply chain security and management platform'
  spec.homepage      = 'https://diffend.io'
  spec.license       = 'Prosperity Public License'

  spec.required_ruby_version = '>= 2.5.0'

  if $PROGRAM_NAME.end_with?('gem')
    spec.signing_key = File.expand_path('~/.ssh/gem-private_key.pem')
  end

  spec.cert_chain    = %w[certs/mensfeld.pem]
  spec.require_paths = %w[lib]

  files_locations.each { |location| spec.files += Dir[location] }

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
