# frozen_string_literal: true

module RouteManagment
  def route_managment
    action_menu_route_managment
    choice_route = gets.chomp.to_i
    case choice_route
    when 1 then create_route
    when 2 then show_route_stations
    when 3 then add_station_in_route
    when 4 then delete_station_in_route
    end
  end

  def create_route
    @stations.each_with_index { |station, _index| puts "#{i.next} - #{station.name}" }
    puts 'Введите номер первой и последней станции: '
    station_first = gets.chomp.to_i
    station_last = gets.chomp.to_i
    @routes.push(route_new(station_first, station_last))
  end

  def show_route_stations
    route_number = route_selection(@routes)
    selected_route(route_number).show_stations
  end

  def add_station_in_route
    route_number = route_selection(@routes)
    @routes[route_number.pred].show_stations
    puts 'Введите номер станции, после которой добавить новую: '
    pred_station_number = gets.chomp.to_i
    show_available_stations
    puts 'Выберите станцию: '
    station_name = gets.chomp
    station_name.capitalize!
    selected_route(route_number).add_station(pred_station_number, new_station_position(station_name))
  end

  def delete_station_in_route
    route_number = route_selection(@routes)
    @routes[route_number.pred].show_stations
    puts 'Выберите станцию, которую хотите удалить из маршрута: '
    station_name = gets.chomp
    station_name.capitalize!
    selected_route.delete_station(new_station_position(station_name))
  end

  def assign_route_to_train
    current_train = train(@trains_list)
    route_number = route_selection(@routes)
    current_train.train_route(@routes[route_number.pred])
    selected_route(route_number).stations.first.add_train(current_train)
  end

  protected

  def action_menu_route_managment
    puts "Введите 1, чтобы создать маршрут.\n
          Введите 2, чтобы просмотреть список станций маршрута.\n
          Введите 3, чтобы добавить станцию.\n
          Введите 4, чтобы удалить станцию."
  end

  def route_selection(routes)
    routes.each_with_index { |route, i| puts "#{i.next} - #{route.name}" }
    puts 'Введите номер маршрута'
    gets.chomp.to_i
  end

  def route_name(station_first, station_last)
    "#{station_first.name}-#{station_last.name}"
  end

  def new_station_position(station_name)
    @stations[@stations.index(station_name)]
  end

  def station(station)
    @stations[station.pred]
  end

  def selected_route(route_number)
    @routes[route_number.pred]
  end

  def show_available_stations
    puts 'Список доступных станций: '
    @stations.each { |station| puts "Станция - #{station.name}" unless @stations.include? station }
  end

  def route_new(station_first, station_last)
    Route.new(route_name(station(station_first), station(station_last)),
              station(station_first), station(station_last))
  end
end
