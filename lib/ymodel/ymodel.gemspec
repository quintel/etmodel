# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'ymodel'
  spec.version       = '0.1.0'
  spec.authors       = ['Steven Kemp']
  spec.email         = ['steven.kemp@quintel.com']

  spec.description   = 'ActiveRecord like interface for wrapping yaml data'
  spec.summary       = spec.description
  spec.homepage      = 'https://www.quintel.com'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/quintel/etmodel/tree/master/lib/ymodel'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.add_development_dependency 'bundler', '~> 1.17'
end
