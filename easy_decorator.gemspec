require_relative 'lib/easy_decorator/version'

Gem::Specification.new do |gem|
  gem.name        = 'easy_decorator'
  gem.version     = EasyDecorator::VERSION
  gem.date        = '2020-10-13'
  gem.authors     = ['Josh Crank']
  gem.email       = 'joshuatcrank@gmail.com'

  gem.summary     = 'A method decorator for Ruby.'
  gem.description = "Bring in Python's decorator pattern for Ruby methods."
  gem.homepage    = 'https://github.com/jtcrank/easy_decorator'
  gem.license     = 'MIT'
  gem.required_ruby_version       = Gem::Requirement.new('>=2.6')

  gem.metadata['homepage_uri']    = gem.homepage
  gem.metadata['source_code_uri'] = gem.homepage
  gem.metadata['changelog_uri']   = gem.homepage

  gem.files = Dir['lib/**/*']
  gem.require_paths = ['lib']
  gem.add_development_dependency 'byebug'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'rubocop-rspec'
  gem.add_development_dependency 'simplecov'
end
