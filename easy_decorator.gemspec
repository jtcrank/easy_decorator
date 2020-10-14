require_relative 'lib/easy_decorator/version'

Gem::Specification.new do |gem|
  gem.name        = 'easy_decorator'
  gem.version     = EasyDecorator::VERSION
  gem.date        = '2020-10-13'
  gem.authors     = ['Josh Crank']
  gem.email       = 'joshuatcrank@gmail.com'

  gem.summary     = %q{A method decorator for Ruby.}
  gem.description = %q{Bring in Python's decorator pattern for Ruby methods.}
  gem.homepage    = 'https://github.com/jtcrank/easy_decorator'
  gem.license     = 'MIT'
  gem.required_ruby_version       = Gem::Requirement.new(">=2.6")

  gem.metadata['homepage_uri']    = gem.homepage
  gem.metadata['source_code_uri'] = gem.homepage
  gem.metadata['changelog_uri']   = gem.homepage

  gem.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f|
      f.match(%r{^(test|spec|features)/})
    }
  end

  gem.require_paths = ['lib']
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'

end
