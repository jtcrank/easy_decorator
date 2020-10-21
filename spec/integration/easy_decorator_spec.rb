# rubocop:disable all

require 'spec_helper'

RSpec.describe EasyDecorator do
  describe 'syntax' do
    let(:valid_class) {
      class ValidClass
        include EasyDecorator
        include Decorators

        decorate(:outer)
        decorate(:inner)
        def test_method(arg)
          arg
        end
      end
    }

    let(:invalid_class) {
      class InvalidClass
        include EasyDecorator
        include Decorators

        decorate(:inner)

        def test_method(arg)
          arg
        end
      end
    }

    it 'works with valid syntax' do
      expect { valid_class }.to_not raise_error
    end


    it 'throws an exception if the decorator is not declared immediately before method definition' do
      expect { invalid_class }.to raise_error(EasyDecorator::InvalidSyntax)
    end
  end

  describe 'behavior' do
    let(:valid_class) {
      class ValidClass
        include EasyDecorator
        include Decorators

        decorate(:outer)
        decorate(:inner)
        def test_method(arg)
          arg
        end
      end

      ValidClass
    }

    let(:invalid_decorator) {
      class InvalidDecoratorClass
        include EasyDecorator

        decorate(:inner)
        def test_method(arg)
          arg
        end
      end
    }

    it 'evaluates decorators in order, and passes correct arguments through the method chain' do
      result = valid_class.new.test_method('it works')
      expect(result).to eq(['outer begin', 'inner begin', 'it works', 'inner end', 'outer end'])
    end

    it 'returns the decorator metadata when calling decorators() on class' do
      result = valid_class.decorators
      expect(result).to_not be_nil
    end

    it 'throws an exception if the decorator method does not exist' do
      expect { invalid_decorator }.to raise_error(EasyDecorator::InvalidDecorator)
    end
  end
end
