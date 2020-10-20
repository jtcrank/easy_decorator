require 'easy_decorator/errors'

module EasyDecorator
  def self.included(base_klass)
    base_klass.extend(ClassMethods)
    base_klass.instance_variable_set(:@decorators, { method_buffer: [] })
    base_klass.define_method :wrapper do |&block|
      block
    end
  end

  module ClassMethods
    def decorate(decorator)
      # get line number of decorator statement and add decorator method to the buffer
      line_num = caller.first.split(':')[1]
      @decorators[:method_buffer].prepend({ decorator: decorator, line: line_num})
    end

    def get_decorators(decorator)
      @decorators
    end

    def method_added(method_name)
      unless @decorators.key?(method_name) || @decorators[:method_buffer].empty?
        # get line number of method definition
        line_num = caller.first.split(':')[1]

        # verify decorators are declared directly before the method definition
        line_nums = @decorators[:method_buffer].map { |m| m[:line].to_i }.reverse << line_num.to_i
        raise EasyDecorator::InvalidSyntax.new(
          'Decorators must be declared on line(s) directly before method definition'
        ) unless line_nums.each_cons(2).all? { |i| (i[1] - i[0]).eql? 1 }

        # Add decorator chain to decorators and clear buffer
        @decorators[method_name] = @decorators[:method_buffer]
        @decorators[:method_buffer] = []

        source_method_name = "source_#{method_name}".to_sym
        alias_method source_method_name, method_name
        method_chain = @decorators[method_name].map { |i| i[:decorator] } << source_method_name

        define_method method_name do |*args|
          method_chain.then { |*funcs, base_func|
            funcs.reduce(public_method(base_func)) { |acc, func|
              public_method(func).call(acc, *args)
            }
          }.call(*args)
        end
      end
    end
  end
end
