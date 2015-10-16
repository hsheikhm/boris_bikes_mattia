require_relative './docking_station'  # => true
require_relative 'van'                # => false

# testing #release_bike, #working? and #dock methods
station = DockingStation.new  # => #<DockingStation:0x007fa269842700 @bikes=[], @capacity=20>
station.dock(Bike.new)        # => [#<Bike:0x007fa2698424f8 @working=true>]
bike = station.release_bike   # => #<Bike:0x007fa2698424f8 @working=true>
bike.working?                 # => true

# testing raising an error when #release_bike with empty station
begin
  station = DockingStation.new  # => #<DockingStation:0x007fa2698420e8 @bikes=[], @capacity=20>
  station.release_bike
rescue RuntimeError=>e
  "Error: #{e}"                 # => "Error: No bikes available"
end                             # => "Error: No bikes available"

station.dock(Bike.new)  # => [#<Bike:0x007fa269841c38 @working=true>]
station.release_bike    # => #<Bike:0x007fa269841c38 @working=true>

# testing if we can dock up to twenty bikes at a station
station = DockingStation.new        # => #<DockingStation:0x007fa269841968 @bikes=[], @capacity=20>
20.times { station.dock(Bike.new)}  # => 20

# testing raising an error when docking a bike at a full station
station = DockingStation.new        # => #<DockingStation:0x007fa2698413c8 @bikes=[], @capacity=20>
20.times {station.dock(Bike.new) }  # => 20
begin
station.dock(Bike.new)
rescue RuntimeError=>e
  "Error: #{e}"                     # => "Error: Docking station full"
end                                 # => "Error: Docking station full"

# testing to report a broken bike
station = DockingStation.new  # => #<DockingStation:0x007fa269840b08 @bikes=[], @capacity=20>
bike = Bike.new               # => #<Bike:0x007fa269840978 @working=true>
station.dock(bike.broken)     # => [#<Bike:0x007fa269840978 @working=false>]

# testing initializing docking station with varying capacity

station = DockingStation.new(50)    # => #<DockingStation:0x007fa269840270 @bikes=[], @capacity=50>
50.times { station.dock(Bike.new)}  # => 50
begin
  station.dock(Bike.new)
rescue RuntimeError=>e
  "Error: #{e}"                     # => "Error: Docking station full"
end                                 # => "Error: Docking station full"

# testing that docking station does not release broken bikes

station = DockingStation.new(5)     # => #<DockingStation:0x007fa26983b2e8 @bikes=[], @capacity=5>
4.times { station.dock(Bike.new) }  # => 4
bike = Bike.new                     # => #<Bike:0x007fa26983aff0 @working=true>
station.dock(bike.broken)           # => [#<Bike:0x007fa26983b158 @working=true>, #<Bike:0x007fa26983b130 @working=true>, #<Bike:0x007fa26983b108 @working=true>, #<Bike:0x007fa26983b0e0 @working=true>, #<Bike:0x007fa26983aff0 @working=false>]
station.release_bike                # => #<Bike:0x007fa26983b158 @working=true>
station.bikes                       # => [#<Bike:0x007fa26983b130 @working=true>, #<Bike:0x007fa26983b108 @working=true>, #<Bike:0x007fa26983b0e0 @working=true>, #<Bike:0x007fa26983aff0 @working=false>]
3.times do                          # => 3
  bike = station.release_bike       # => #<Bike:0x007fa26983b130 @working=true>, #<Bike:0x007fa26983b108 @working=true>, #<Bike:0x007fa26983b0e0 @working=true>
  station.dock(bike.broken)         # => [#<Bike:0x007fa26983b108 @working=true>, #<Bike:0x007fa26983b0e0 @working=true>, #<Bike:0x007fa26983aff0 @working=false>, #<Bike:0x007fa26983b130 @working=false>], [#<Bike:0x007fa26983b0e0 @working=true>, #<Bike:0x007fa26983aff0 @working=false>, #<Bike:0x007fa26983b130 @working=false>, #<Bike:0x007fa26983b108 @working=false>], [#<Bike:0x007fa26983aff0 @working=false>, #<Bike:0x007fa26983b130 @working=false>, #<Bike:0x007fa26983b108 @working=false>, #<Bike:0x007fa26983b0e0 @working=false>]
end                                 # => 3
begin
station.release_bike
rescue RuntimeError=>e
  "Error: #{e}"                     # => "Error: No bikes available"
end                                 # => "Error: No bikes available"

# testing if a van can collect broken bikes from docking station and delivers them to a garage

station = DockingStation.new                # => #<DockingStation:0x007fa2698391c8 @bikes=[], @capacity=20>
2.times { station.dock(Bike.new.broken) }   # => 2
station.dock(Bike.new)                      # => [#<Bike:0x007fa269839038 @working=false>, #<Bike:0x007fa269839010 @working=false>, #<Bike:0x007fa269838ef8 @working=true>]
station.bikes                               # => [#<Bike:0x007fa269839038 @working=false>, #<Bike:0x007fa269839010 @working=false>, #<Bike:0x007fa269838ef8 @working=true>]
van = Van.new                               # => #<Van:0x007fa269838a48 @garage=[]>
broken_bikes = station.remove_broken_bikes  # => [#<Bike:0x007fa269839038 @working=false>, #<Bike:0x007fa269839010 @working=false>, #<Bike:0x007fa269838ef8 @working=false>]
van.push_broken_bikes(broken_bikes)         # ~> NameError: undefined local variable or method `remove_broken_bikes' for #<Van:0x007fa269838a48 @garage=[]>
van.garage

# ~> NameError
# ~> undefined local variable or method `remove_broken_bikes' for #<Van:0x007fa269838a48 @garage=[]>
# ~>
# ~> /Users/Hamza/Desktop/Programming/Makers Academy/Week 1/Today/boris_bikes_mattia/lib/van.rb:12:in `push_broken_bikes'
# ~> /Users/Hamza/Desktop/Programming/Makers Academy/Week 1/Today/boris_bikes_mattia/lib/feature_test.rb:75:in `<main>'
