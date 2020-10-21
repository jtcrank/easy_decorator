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
      @decorators[:method_buffer].prepend({ decorator: decorator, line: line_num })
    end

    def decorators
      @decorators
    end

    def method_added(method_name)
      return if bypass_method_added(method_name)

      # validate correct syntax
      method_line = caller.first.split(':')[1]
      validate_syntax(method_line)

      source_method_name = "easy_decorator_#{method_name}".to_sym
      alias_method source_method_name, method_name
      method_chain = build_method_chain(method_name)
      setup_decorated_method(method_name, method_chain)
    end

    private

    def bypass_method_added(method_name)
      [
        method_name.to_s.start_with?('easy_decorator_'),
        @decorators.key?(method_name),
        @decorators[:method_buffer].empty?
      ].any?
    end

    def build_method_chain(method_name)
      validate_decorators(@decorators[:method_buffer])
      @decorators[method_name] = @decorators[:method_buffer]
      @decorators[:method_buffer] = []
      source_method_name = "source_#{method_name}".to_sym
      alias_method source_method_name, method_name

      @decorators[method_name].map { |i| i[:decorator] } << source_method_name
    end

    def setup_decorated_method(method_name, method_chain)
      define_method method_name do |*args|
        method_chain.then do |*funcs, base_func|
          funcs.reduce(public_method(base_func)) do |acc, func|
            public_method(func).call(acc, *args)
          end
        end.call(*args)
      end
    end

    def validate_syntax(method_line)
      # verify decorators are declared directly before the method definition
      line_nums = @decorators[:method_buffer].map { |m| m[:line].to_i }.reverse << method_line.to_i
      is_valid = line_nums.each_cons(2).all? { |i| (i[1] - i[0]).eql? 1 }

      unless is_valid
        raise EasyDecorator::InvalidSyntax, 'Decorators must be declared on line(s) directly before method definition'
      end

      is_valid
    end

    def validate_decorators(method_buffer)
      invalid_methods = method_buffer.filter { |m| !method_defined? m[:decorator] }
      is_valid = invalid_methods.empty?

      raise(EasyDecorator::InvalidDecorator, "Decorator(s) not defined:\n\t#{invalid_methods}") unless is_valid

      is_valid
    end
  end
end
