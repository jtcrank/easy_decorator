module Decorators
  def outer(func, *args)
    wrapper do
      result = ['outer begin']
      result << func.call(*args)
      result << 'outer end'

      result.flatten
    end
  end

  def inner(func, *args)
    wrapper do
      result = ['inner begin']
      result << func.call(*args)
      result << 'inner end'

      result.flatten
    end
  end
end
