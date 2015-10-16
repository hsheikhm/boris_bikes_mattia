require_relative 'docking_station.rb'  # => true

class Van

attr_reader :garage

  def initialize
    @garage = []
  end

  def deliver(broken_bikes)
    broken_bikes.each { |bike| @garage << bike }
  end

end
