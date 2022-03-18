# frozen_string_literal: true

module Accessors
  def self.included(base_class)
    base_class.extend ClassMethods
    base_class.include InstanceMethods
  end

  module ClassMethods
    def attr_accessors_with_history(*methods)
      methods.each do |method|
        raise TypeError, 'Method name is not symbol!' unless method.is_a?(Symbol)

        define_method(method) { instance_variable_get("@#{method}") }
        define_method("#{method}=") do |value|
          instance_variable_get("@#{method}_history").push(instance_variable_get("@#{method}")) ||
            instance_variable_set("@#{method}_history", [])
          instance_variable_set("@#{method}", value)
        end
        define_method("#{method}_history") { instance_variable_get("@#{method}_history") }
      end
    end
  end

  module InstanceMethods
    def strong_attr_accessor(name, object_class)
      define_method(name) do
        instance_variable_get("@#{name}")
      end
      define_method("#{name}=") do |value|
        value.instance_of?(object_class) ? instance_variable_set("@#{method}", value) : raise("The type don't match!")
      end
    end
  end
end
