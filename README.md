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
```
# ./Gemfile

source 'https://rubygems.org`
...
gem 'easy_decorator', '~> 0.1.0'
```
# Usage
### Include Module
```
# ./my_class.rb
class MyClass
  include EasyDecorator
end
```
### Define Decorator
A decorator should be defined as a method taking in a `method_name` and splat `*args`. Then you just write your code and call the inner function via `send(method_name, *args)`.
```
def my_decorator(method_name, *args)
  ...
  send(method_name, *args)
  ...
end
```
### Decorating Methods
```
decorate(:my_decorator, :my_method)
def my_method(a, b)
  ...
end
```

### Example
```
# ./calculator.rb

class Calculator
  # include module
  include EasyDecorator

  # define decorator
  def time_calculation(method_name, *args)
    logger.info("Timing #{method_name}...")
    start_time = Time.now
    # call inner method
    result = send(method_name, *args)
    end_time = Time.now
    logger.info("Processing Time: #{end_time - start_time}")
  
    return result
  end

  # decorate method
  decorate(:time_calculation, :add_numbers)
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
