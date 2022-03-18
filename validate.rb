# frozen_string_literal: true

module Validate
  def self.validate(name, type, parameter)
    case type
    when :presence
      raise 'Значение атрибута отсутствует!' if name.nil?
    when :format
      raise 'Несоответствие значения агрумента шаблону!' if name !~ parameter
    when :type
      raise 'Несоответствие типов!' if name.class != parameter
    end
  end

  def validate!(name, type, parameter)
    self.class.validate(name, type, parameter)
  end

  def valid?(name, type = nil, parameter = nil)
    validate!(name, type, parameter)
    true
  rescue StandardError
    false
  end
end
