require_relative 'docking_station'  # => true
require_relative 'van'              # => true

# testing #release_bike, #working? and #dock methods
station = DockingStation.new  # => #<DockingStation:0x007fc932022a08 @bikes=[], @capacity=20>
station.dock(Bike.new)        # => [#<Bike:0x007fc932022850 @working=true>]
bike = station.release_bike   # => #<Bike:0x007fc932022850 @working=true>
bike.working?                 # => true

# testing raising an error when #release_bike with empty station
begin
  station = DockingStation.new  # => #<DockingStation:0x007fc9320223c8 @bikes=[], @capacity=20>
  station.release_bike
rescue RuntimeError=>e
  "Error: #{e}"                 # => "Error: No bikes available"
end                             # => "Error: No bikes available"

station.dock(Bike.new)  # => [#<Bike:0x007fc932021f68 @working=true>]
station.release_bike    # => #<Bike:0x007fc932021f68 @working=true>

# testing if we can dock up to twenty bikes at a station
station = DockingStation.new        # => #<DockingStation:0x007fc932021c70 @bikes=[], @capacity=20>
20.times { station.dock(Bike.new)}  # => 20

# testing raising an error when docking a bike at a full station
station = DockingStation.new        # => #<DockingStation:0x007fc9320216a8 @bikes=[], @capacity=20>
20.times {station.dock(Bike.new) }  # => 20
begin
station.dock(Bike.new)
rescue RuntimeError=>e
  "Error: #{e}"                     # => "Error: Docking station full"
end                                 # => "Error: Docking station full"

# testing to report a broken bike
station = DockingStation.new  # => #<DockingStation:0x007fc932020e10 @bikes=[], @capacity=20>
bike = Bike.new               # => #<Bike:0x007fc932020c80 @working=true>
station.dock(bike.broken)     # => [#<Bike:0x007fc932020c80 @working=false>]

# testing initializing docking station with varying capacity

station = DockingStation.new(50)    # => #<DockingStation:0x007fc932020960 @bikes=[], @capacity=50>
50.times { station.dock(Bike.new)}  # => 50
begin
  station.dock(Bike.new)
rescue RuntimeError=>e
  "Error: #{e}"                     # => "Error: Docking station full"
end                                 # => "Error: Docking station full"

# testing that docking station does not release broken bikes

station = DockingStation.new(5)     # => #<DockingStation:0x007fc93201b488 @bikes=[], @capacity=5>
4.times { station.dock(Bike.new) }  # => 4
bike = Bike.new                     # => #<Bike:0x007fc93201b190 @working=true>
station.dock(bike.broken)           # => [#<Bike:0x007fc93201b2f8 @working=true>, #<Bike:0x007fc93201b2d0 @working=true>, #<Bike:0x007fc93201b2a8 @working=true>, #<Bike:0x007fc93201b280 @working=true>, #<Bike:0x007fc93201b190 @working=false>]
station.release_bike                # => #<Bike:0x007fc93201b2f8 @working=true>
station.bikes                       # => [#<Bike:0x007fc93201b2d0 @working=true>, #<Bike:0x007fc93201b2a8 @working=true>, #<Bike:0x007fc93201b280 @working=true>, #<Bike:0x007fc93201b190 @working=false>]
3.times do                          # => 3
  bike = station.release_bike       # => #<Bike:0x007fc93201b2d0 @working=true>, #<Bike:0x007fc93201b2a8 @working=true>, #<Bike:0x007fc93201b280 @working=true>
  station.dock(bike.broken)         # => [#<Bike:0x007fc93201b2a8 @working=true>, #<Bike:0x007fc93201b280 @working=true>, #<Bike:0x007fc93201b190 @working=false>, #<Bike:0x007fc93201b2d0 @working=false>], [#<Bike:0x007fc93201b280 @working=true>, #<Bike:0x007fc93201b190 @working=false>, #<Bike:0x007fc93201b2d0 @working=false>, #<Bike:0x007fc93201b2a8 @working=false>], [#<Bike:0x007fc93201b190 @working=false>, #<Bike:0x007fc93201b2d0 @working=false>, #<Bike:0x007fc93201b2a8 @working=false>, #<Bike:0x007fc93201b280 @working=false>]
end                                 # => 3
begin
station.release_bike
rescue RuntimeError=>e
  "Error: #{e}"                     # => "Error: No bikes available"
end                                 # => "Error: No bikes available"

# testing if a van can collect broken bikes from docking station and deliver them to a garage

station = DockingStation.new                # => #<DockingStation:0x007fc932019390 @bikes=[], @capacity=20>
station.dock(Bike.new)                      # => [#<Bike:0x007fc932019200 @working=true>]
3.times { station.dock(Bike.new.broken) }   # => 3
station.bikes                               # => [#<Bike:0x007fc932019200 @working=true>, #<Bike:0x007fc932019098 @working=false>, #<Bike:0x007fc932019070 @working=false>, #<Bike:0x007fc932019048 @working=false>]
broken_bikes = station.remove_broken_bikes  # => [#<Bike:0x007fc932019098 @working=false>, #<Bike:0x007fc932019070 @working=false>, #<Bike:0x007fc932019048 @working=false>]
station.bikes                               # => [#<Bike:0x007fc932019200 @working=true>]
van = Van.new                               # => #<Van:0x007fc932018800 @garage=[]>
van.deliver_broken_bikes(broken_bikes)      # => [#<Bike:0x007fc932019098 @working=false>, #<Bike:0x007fc932019070 @working=false>, #<Bike:0x007fc932019048 @working=false>]
van.garage                                  # => [#<Bike:0x007fc932019098 @working=false>, #<Bike:0x007fc932019070 @working=false>, #<Bike:0x007fc932019048 @working=false>]
