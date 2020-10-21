require 'simplecov'

SimpleCov.start do
  add_group 'Lib', 'lib'
  add_group 'Tests', 'spec'
end
SimpleCov.minimum_coverage 90

require 'easy_decorator'
require 'byebug'
require 'rspec'

Dir[File.expand_path('spec/fixtures/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
end
