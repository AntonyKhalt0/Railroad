# frozen_string_literal: true

module CreateTrain
  def create_train
    puts 'Введите номер поезда: '
    train_number = gets.chomp.to_i
    puts "Введите 1, чтобы создать пассажирский поезд.\n
          Введите 2 чтобы создать грузовой поезд. "
    choice_type_train = gets.chomp.to_i
    case choice_type_train
    when 1 then create_passenger_train(train_number)
    when 2 then create_cargo_train(train_number)
    end
  end

  protected

  def create_passenger_train(train_number)
    train = @trains_list.push(PassengerTrain.new(train_number))
    puts 'Пассажирский поезд создан!'
    PassengerTrain.add_trains_list(train)
  end

  def create_cargo_train(train_number)
    train = @trains_list.push(CargoTrain.new(train_number))
    puts 'Грузовой поезд создан!'
    CargoTrain.add_trains_list(train)
  end

  def train(trains_list)
    puts 'Введите номер поезда: '
    train_number = gets.chomp.to_i
    trains_list[trains_list.index(train_number)]
  end
end
