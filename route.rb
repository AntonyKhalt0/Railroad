# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'accessors'
require_relative 'validate'

class Route
  include InstanceCounter
  include Accessors
  include Validate

  attr_reader :name, :stations

  # validate :name, :presence

  def intialize(name, first_station, last_station)
    @name = name
    @stations = [first_station, last_station]
    register_instance
    raise 'Объект не создан. Неверные данные.' unless valid?(name, :presence) ||
                                                      valid?(first_station,
                                                             :presence) || valid?(first_station, :type, Station) ||
                                                      valid?(last_station,
                                                             :presence) || valid?(last_station, :type, Station)
  end

  def add_station(previous_station, new_station)
    @stations.insert(@stations.index(previous_station) + 1, new_station)
  end

  def delete_station(selected_station)
    @stations.delete(selected_station)
  end

  def show_stations
    @stations.each_with_index { |station, index| "#{index.next} - станция: #{station.name}" }
  end
end
