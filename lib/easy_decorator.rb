module EasyDecorator
  def self.prepended(base_klass)
    @base_klass = base_klass
  end

  def self.decorate(wrapper, wrapped)
    source_method_name = "source_#{wrapped}".to_sym
    cloned_method = @base_klass.instance_method(wrapped).clone
    @base_klass.define_method(source_method_name, cloned_method)
    
    define_method wrapped do |*arguments|
      send(wrapper, source_method_name, *arguments)
    end
  end
end
