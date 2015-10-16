class Bike

  attr_reader :working  # => nil

  def initialize
    @working = true
  end

  def working?
    @working
  end

  def broken
    @working = false
    self
  end

end
