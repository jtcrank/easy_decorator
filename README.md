# EasyDecorator

EasyDecorator is a module that bring's in a Python-like method decorator pattern into Ruby.

# Table of Contents

* [Installation](#installation)
* [Usage](#usage)
  * [Include Module](#include-module)
  * [Define Decorator](#define-decorator)
  * [Decorating Methods](#decorating-methods)
  * [Example](#example)
* [Contributing](#contributing)

# Installation
### command line
`$ gem install easy_decorator`

### Gemfile
```ruby
# ./Gemfile

source 'https://rubygems.org`
# ...
gem 'easy_decorator', '~> 0.2.0'
```
# Usage
### Include Module
```ruby
# ./my_class.rb
class MyClass
  include EasyDecorator
end
```
### Define Decorator
A decorator should be defined as a method with an inner wrapper. Within the wrapper you can call the passed method via `func.call(*args)`.

```ruby
def my_decorator(func, *args)
  wrapper do 
    # code here
    func.call(*args)
    # code here
  end
end
```
\* `wrapper` is essentially syntactic sugar for a proc.

### Decorating Methods
```ruby
decorate(:my_method, :my_decorator)
def my_method(a, b)
  # code here
end
```
You can apply multiple decorators to a method, which will applies from last to first declared.

```ruby
decorate(:my_method, :outer_decorator)
decorate(:my_method, :inner_decorator)
def my_method(*args)
  # ...
end

# is essentially the same as:
outer_decorator(inner_decorator(public_method(:my_method))).call(*args)
```

### Example
```ruby
# ./calculator.rb

class Calculator
  # include module
  include EasyDecorator

  # define decorator
  def calculate_time(func, *args)
    wrap do
      logger.info("Timing #{method_name}...")
      start_time = Time.now
      # call inner method
      result = func.call(*args)
      end_time = Time.now
      logger.info("Processing Time: #{end_time - start_time}")

      result
    end
  end

  # decorate method
  decorate(:add_numbers, :calculate_time)
  def add_numbers(a, b)
    return a + b
  end
end
```
Result:
```
$ Calculator.new.add_numbers(1,2)
Timing add_numbers...
Processing Time: 0.0001572930
=> 3
```

# Contributing
1. Fork the repo
2. Create a your feature branch (`git checkout -b my-feature-branch`)
3. Update CHANGELOG.md with a bulleted list of your changes under the `unreleased` heading.
4. Include rspec tests for your changes
5. Commit your changes to your branch (`git commit -am 'Added my feature'`)
6. Push to your remote forked repo (`git push origin my-featuer-branch`)
7. Create a new Pull Request
Once I am able to review the pull request, I will either either approve and merge, or give feedback on it if I do not merge it. I will do my best to address Pull Requests as time allows.
