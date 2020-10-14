require 'easy_decorator/errors'

module EasyDecorator
  def self.included(base_klass)
    base_klass.extend(ClassMethods)
    base_klass.instance_variable_set(:@decorated_methods, {})
  end

  module ClassMethods
    def decorate(decorator, decorated)
      @decorated_methods[decorated] = {
        decorator: decorator,
        is_decorated: false
      }
    end

    def method_added(method_name)
      decorator = @decorated_methods[method_name]
      if decorator && !decorator[:is_decorated]
        decorator[:is_decorated] = true
        source_method_name = "source_#{method_name}".to_sym
        alias_method source_method_name, method_name

        define_method method_name do |*args|
          send(decorator[:decorator], source_method_name, *args)
        end
      end
    end
  end
end

