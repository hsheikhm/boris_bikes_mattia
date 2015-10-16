require_relative './docking_station'  # => true

# testing #release_bike, #working? and #dock methods
station = DockingStation.new  # => #<DockingStation:0x007fb041887068 @bikes=[], @capacity=20>
station.dock(Bike.new)        # => [#<Bike:0x007fb041886eb0 @working=true>]
bike = station.release_bike   # => #<Bike:0x007fb041886eb0 @working=true>
bike.working?                 # => true

# testing raising an error when #release_bike with empty station
begin
  station = DockingStation.new  # => #<DockingStation:0x007fb041886960 @bikes=[], @capacity=20>
  station.release_bike
rescue RuntimeError=>e
  "Error: #{e}"                 # => "Error: No bikes available"
end                             # => "Error: No bikes available"

station.dock(Bike.new)  # => [#<Bike:0x007fb041886528 @working=true>]
station.release_bike    # => #<Bike:0x007fb041886528 @working=true>

# testing if we can dock up to twenty bikes at a station
station = DockingStation.new        # => #<DockingStation:0x007fb041885f60 @bikes=[], @capacity=20>
20.times { station.dock(Bike.new)}  # => 20

# testing raising an error when docking a bike at a full station
station = DockingStation.new        # => #<DockingStation:0x007fb041885768 @bikes=[], @capacity=20>
20.times {station.dock(Bike.new) }  # => 20
begin
station.dock(Bike.new)
rescue RuntimeError=>e
  "Error: #{e}"                     # => "Error: Docking station full"
end                                 # => "Error: Docking station full"

# testing to report a broken bike
station = DockingStation.new  # => #<DockingStation:0x007fb041884840 @bikes=[], @capacity=20>
bike = Bike.new               # => #<Bike:0x007fb041884660 @working=true>
station.dock(bike.broken)     # => [#<Bike:0x007fb041884660 @working=false>]

# testing initializing docking station with varying capacity

station = DockingStation.new(50)    # => #<DockingStation:0x007fb0418842c8 @bikes=[], @capacity=50>
50.times { station.dock(Bike.new)}  # => 50
begin
  station.dock(Bike.new)
rescue RuntimeError=>e
  "Error: #{e}"                     # => "Error: Docking station full"
end                                 # => "Error: Docking station full"

# testing that docking station does not release broken bikes

station = DockingStation.new(5)     # => #<DockingStation:0x007fb04187f480 @bikes=[], @capacity=5>
4.times { station.dock(Bike.new) }  # => 4
bike = Bike.new                     # => #<Bike:0x007fb04187f138 @working=true>
station.dock(bike.broken)           # => [#<Bike:0x007fb04187f2a0 @working=true>, #<Bike:0x007fb04187f278 @working=true>, #<Bike:0x007fb04187f250 @working=true>, #<Bike:0x007fb04187f228 @working=true>, #<Bike:0x007fb04187f138 @working=false>]
station.release_bike                # => #<Bike:0x007fb04187f2a0 @working=true>
station.bikes                       # => [#<Bike:0x007fb04187f278 @working=true>, #<Bike:0x007fb04187f250 @working=true>, #<Bike:0x007fb04187f228 @working=true>, #<Bike:0x007fb04187f138 @working=false>]
3.times do                          # => 3
  bike = station.release_bike       # => #<Bike:0x007fb04187f278 @working=true>, #<Bike:0x007fb04187f250 @working=true>, #<Bike:0x007fb04187f228 @working=true>
  station.dock(bike.broken)         # => [#<Bike:0x007fb04187f250 @working=true>, #<Bike:0x007fb04187f228 @working=true>, #<Bike:0x007fb04187f138 @working=false>, #<Bike:0x007fb04187f278 @working=false>], [#<Bike:0x007fb04187f228 @working=true>, #<Bike:0x007fb04187f138 @working=false>, #<Bike:0x007fb04187f278 @working=false>, #<Bike:0x007fb04187f250 @working=false>], [#<Bike:0x007fb04187f138 @working=false>, #<Bike:0x007fb04187f278 @working=false>, #<Bike:0x007fb04187f250 @working=false>, #<Bike:0x007fb04187f228 @working=false>]
end                                 # => 3
begin
station.release_bike
rescue RuntimeError=>e
  "Error: #{e}"                     # => "Error: No bikes available"
end                                 # => "Error: No bikes available"
