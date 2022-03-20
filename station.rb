# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'accessors'
require_relative 'validate'

class Station
  include InstanceCounter
  include Accessors
  include Validate

  NAME_STATION = /^[а-яА-Я]+$/.freeze

  attr_reader :name, :trains_list

  attr_accessors_with_history :stations_list

  # @stations_list = []

  #  class << self
  #    def add_station_list(station)
  #      @@stations_list.push(station)
  #    end

  #    def all
  #      @@stations_list
  #    end

  # end

  def initialize(name)
    @name = name
    @trains_list = []
    register_instance
  end

  def add_train(train)
    @train_list.push(train)
  end

  def send_train(train)
    @trains_list.delete(train) if @trains_list.include? train
  end

  def show_trains_on_station_by_type(type)
    @trains_list.select { |train| train.type == type }
  end

  def passage_on_trains(&block)
    @trains_list.each { |train| block.call(train) }
  end
end
