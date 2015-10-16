require_relative 'bike'
require_relative 'van'

class DockingStation
  attr_reader :bikes, :capacity, :garage

  DEFAULT_CAPACITY = 20

  def initialize(capacity=DEFAULT_CAPACITY)
    @bikes =[]
    @capacity = capacity
    
  end

  def release_bike
    #raise 'No bikes available' if empty?
    bikes.each { |bike| return bikes.delete(bike) if bike.working? }
    raise 'No bikes available'
  end

  def dock(bike)
    raise 'Docking station full' if full?
    bikes << bike
  end

  def remove_broken_bikes
    #bikes.each { |bike| bikes.delete(bike) if bike.broken }
    bikes.select do |bike|
      bike.broken
    end

  end

  private               # => DockingStation
  def full?
    bikes.length >= @capacity
  end

  # def empty?
  #   bikes.empty?
  # end

end
