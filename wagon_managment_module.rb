# frozen_string_literal: true

module WagonManagment
  def wagons_managment
    current_train = train(@trains_list)
    action_menu_wagon_managment
    select_action_with_wagon = gets.chomp.to_i
    case select_action_with_wagon
    when 1 then current_train.passage_on_wagons(railcar_output_block)
    when 2 then filling_wagon(current_train)
    when 3 then attach_wagon(current_train)
    when 4 then unpin_wagon(current_train)
    end
  end

  def attach_wagon(current_train)
    puts 'Введите объем вагона: ' if current_train.type == 'Cargo'
    puts 'Введите количество мест вагона: ' if current_train.type == 'Passenger'
    values = gets.chomp.to_i
    case current_train.type
    when 'Cargo'
      wagon = CargoWagon.new(values)
    when 'Passenger'
      wagon = PassengerWagon.new(values)
    end
    current_train.attach_wagons(wagon)
  end

  def unpin_wagon(current_train)
    puts "Количеcтво вагонов поезда: #{current_train.wagons.length}\n
          Введите номер удаляемого вагона: "
    wagon_index = gets.chomp.to_i
    current_train.unpin_wagons(wagon_index)
  end

  def filling_wagon(current_train)
    puts "Количеcтво вагонов поезда: #{current_train.wagons.length}\nВведите номер вагона: "
    wagon_index = gets.chomp.to_i
    case current_train.type
    when 'Cargo'
      puts 'Введите объем груза: '
      cargo_volume = gets.chomp.to_i
      current_train_wagon(current_train, wagon_index).filling_in_volume(cargo_volume)
    when 'Passenger'
      current_train_wagon(current_train, wagon_index).filling_places
    end
  end

  protected

  def action_menu_wagon_managment
    puts "Введите 1, чтобы просмотреть вагоны поезда.\n
          Введите 2, чтобы заполнить вагон поезда.\n
          Введите 3, чтобы добавить вагон.\n
          Введите 4, чтобы отцепить вагон."
  end

  def current_train_wagon(current_train, wagon_index)
    current_train.wagons[wagon_index.pred]
  end
end
