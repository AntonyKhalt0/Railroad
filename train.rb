# frozen_string_literal: true

require_relative 'manufactures_name'
require_relative 'instance_counter'
require_relative 'accessors'
require_relative 'validate'

class Train
  include ManufacturesName
  include InstanceCounter
  include Accessors
  include Validate

  NUMBER_TRAIN = /^([а-яА-Я]{3}|\d{3})-?([а-яА-Я]{2}|\d{2})$/.freeze

  attr_reader :number, :wagons, :route, :speed, :current_station

  # validate :number, :presence
  # validate :number, :format, NUMBER_TRAIN
  # validate :route, :type, Route

  @trains_list = []

  class << self
    def add_trains_list(train)
      @@trains_list.push(train)
    end

    def find(train_number)
      @@trains_list.each { |train| train.number == train_number ? train : nil }
    end

    protected

    attr_accessor :trains_list
  end

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    register_instance
    raise 'Объект не создан. Неверные данные.' unless valid?(number, :presence) || valid?(number, :format, NUMBER_TRAIN)
  end

  def speed_dial(boost)
    self.speed += boost
  end

  def reduse_speed
    self.speed = 0
  end

  def attach_wagons(wagon)
    @wagons.push(wagon) if speed_zero? && wagon.type == type
  end

  def unpin_wagons(wagon_index)
    @wagons.delete_at(wagon_index) if speed_zero?
  end

  def train_route(route)
    @route = route
    @current_station = route_stations.fisrt
  end

  def previous_station
    route_stations[current_stations_index.pred] if @current_station != route_stations.fisrt
  end

  def next_station
    route_stations[current_stations_index.next] if @current_station != route_stations.last
  end

  def moving_back
    @current_station = previous_station if previous_station
  end

  def moving_forward
    @current_station = next_station if next_station
  end

  def passage_on_wagons(&block)
    @wagons.each { |wagon| block.call(wagon) }
  end

  protected # Private заменил на protected, чтобы заприваченные методы были видны в классах-потомках

  attr_writer :speed # Переместил setter скорости, чтобы нельзя было изменять "из вне"

  # Методы дополнительного функционала вынес в protected
  def speed_zero?
    self.speed.zero?
  end

  def route_stations
    @route.stations
  end

  def current_stations_index
    route_stations.index(@current_station)
  end
end
