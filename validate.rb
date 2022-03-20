# frozen_string_literal: true

module Validate
  def self.included(base_class)
    base_class.extend ClassMethods
    base_class.include InstanceMethods
  end

  module ClassMethods
    def validate(var_name, validate_type, args = nil)
      @checked_values ||= []
      @checked_values.push({ var_name: var_name, validate_type: validate_type, args: args })
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    protected

    def validate!
      self.class.checked_values.each do |checked_value|
        send(checked_value[:validate_type].to_s, checked_value)
      end
    end

    def method_missing(method_name, *args)
      case method_name
      when :presence
        raise 'Значение атрибута отсутствует!' if args[:var_name].nil?
      when :format
        raise 'Несоответствие значения агрумента шаблону!' if args[:var_name] !~ args[:args]
      when :type
        raise 'Несоответствие типов!' if args[:var_name].class != args[:args]
      end
    end
  end
end
