require 'easy_decorator/errors'

module EasyDecorator
  def self.included(base_klass)
    base_klass.extend(ClassMethods)
    base_klass.instance_variable_set(:@decorated_methods, {})
    base_klass.define_method :wrapper do |&block|
      block
    end
  end

  module ClassMethods
    def decorate(decorated, decorator)
      @decorated_methods[decorated] ||= { method_chain: [], is_decorated: false }
      @decorated_methods[decorated][:method_chain] << decorator
    end

    def method_added(method_name)
      decorator = @decorated_methods[method_name]

      if decorator && !decorator[:is_decorated]
        decorator[:is_decorated] = true

        source_method_name = "source_#{method_name}".to_sym
        alias_method source_method_name, method_name
        decorator[:method_chain] << source_method_name

        define_method method_name do |*args|
          decorator[:method_chain].then { |*funcs, base_func|
            funcs.reduce(public_method(base_func)) { |acc, func|
              public_method(func).call(acc, *args)
            }
          }.call(*args)
        end
      end
    end
  end
end
