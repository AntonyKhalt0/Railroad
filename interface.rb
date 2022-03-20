# frozen_string_literal: true

require_relative 'route_managment_module'
require_relative 'wagons_managment_module'
require_relative 'create_train_module'

class Interface
  include RouteManagment
  include WagonManagment
  include CreateTrain

  def initialize
    @stations = []
    @trains_list = []
    @routes = []
  end

  def action_menu
    loop do
      show_action_menu
      choice = gets.chomp.to_i
      first_choosing_action(choice)
      second_choosing_action(choice)
    end
  end

  protected

  def create_station
    puts 'Введите название станции: '
    station_name = gets.chomp
    station_name.capitalize!
    Station.validate(station_name, :presence)
    station = Station.new(station_name)
    puts 'Станция создана!'
    @stations.push(station) if station.valid?
    Station.add_stations_list(station)
  end

  def move_the_train
    current_train = train(@trains_list)
    puts "Введите 1, чтобы переместить поезд вперед на одну станцию.\n
          Введите 2, чтобы переместить поезд назад на одну станцию."
    moving = gets.chomp
    case moving
    when 1
      move_forward(current_train)
    when 2
      move_back(current_train)
    end
  end

  def move_forward(current_train)
    return unless current_train.moving_forward

    current_train.previous_station.send_train(current_train)
    add_train_on_station(current_train)
  end

  def move_back(current_train)
    return unless current_train.moving_back

    current_train.next_station.send_train(current_train)
    add_train_on_station(current_train)
  end

  def show_trains_on_stations
    @stations.each_with_index do |station, _index|
      puts "Станция - #{station.name}. Поезда на станции: "
      station.passage_on_trains do
        puts "Номер: #{train.number}, тип: #{train.type},\
                                  вагоны: #{train.passage_on_wagons(railcar_output_block)}"
      end
    end
  end

  def show_action_menu
    puts "Введите 1, чтобы создать станцию.\n
          Введите 2, чтобы создать поезд.\n
          Введите 3, чтобы создать маршрут и управлять станциями в нем.\n
          Введите 4, чтобы назначить маршрут поезду.\n
          Введите 5, чтобы управлять вагонами поезда.\n
          Введите 6, чтобы перемещать поезд по маршруту.\n
          Введите 7, чтобы просматривать список станций и список поездов на станции.
          Введите 8, чтобы выйти из программы. "
  end

  def first_choosing_action(choice)
    case choice
    when 1 then create_station
    when 2 then create_train
    when 3 then route_managment
    when 4 then assign_route_to_train
    end
  end

  def second_choosing_action(choice)
    case choice
    when 5 then wagons_managment
    when 6 then move_the_train
    when 7 then show_trains_on_stations
    when 8 then break
    end
  end

  def add_train_on_station(current_train)
    current_train.current_station.add_train(current_train)
  end

  def wagon_of(current_train)
    PassengerWagon.new if current_train.type == 'Passenger'
    CargoWagon.new if current_train.type == 'Cargo'
  end

  def railcar_output_block
    lambda {
      puts "Вагон: #{wagon.type}, свободно: #{wagon.available_value}, \
                    занято: #{wagon.occupied_value}"
    }
  end
end
