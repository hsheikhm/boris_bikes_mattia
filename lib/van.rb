require_relative 'docking_station.rb'  # => true

class Van

attr_reader :garage

  def initialize
    @garage = []
  end

  def push_broken_bikes(broken_bikes)
    @garage << remove_broken_bikes 
  end

end
