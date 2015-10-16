
require_relative 'bike'

class DockingStation
  attr_reader :bikes, :capacity

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

  private               # => DockingStation
  def full?
    bikes.length >= @capacity
  end

  # def empty?
  #   bikes.empty?
  # end

end
