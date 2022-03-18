# frozen_string_literal: true

module Validate
  def self.included(base_class)
    base_class.extend ClassMethods
    base_class.include InstanceMethods
  end

  module ClassMethods
    def validate(name, type, parameter = nil)
      case type
      when :presence
        raise 'Значение атрибута отсутствует!' if name.nil?
      when :format
        raise 'Несоответствие значения агрумента шаблону!' if name !~ parameter
      when :type
        raise 'Несоответствие типов!' if name.class != parameter
      end
    end
  end

  module InstanceMethods
    def valid?(name, type = nil, parameter = nil)
      validate!(name, type, parameter)
      true
    rescue StandardError
      false
    end

    protected

    def validate!(name, type, parameter)
      self.class.validate(name, type, parameter)
    end
  end
end
