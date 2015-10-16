require 'van'
require 'docking_station'

describe Van do

  let(:bike) { double :bike }

it { is_expected.to respond_to(:deliver).with(1).argument }

  describe '#deliver_broken_bikes' do
    it 'delivers broken bikes to garage' do
      allow(bike).to receive(:working?).and_return(true)

      station = DockingStation.new
      station.dock(bike)
      3.times { station.dock(Bike.new.broken) }
      broken_bikes = station.remove_broken_bikes
      subject.deliver(broken_bikes)
      expect(subject.garage).to eq broken_bikes
    end
  end
end
