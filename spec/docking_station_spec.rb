require 'docking_station'
require 'van'

describe DockingStation do

  let(:bike) { double :bike }

  it { is_expected.to respond_to(:release_bike) }
  it { is_expected.to respond_to(:dock).with(1).argument}

  context 'initializing DockingStation' do
    it 'has #DEFAULT_CAPACITY of 20' do
      expect(subject.capacity).to eq DockingStation::DEFAULT_CAPACITY
    end
    it 'can have varying capacity' do
      station = DockingStation.new(50)
      expect(station.capacity).to eq 50
    end
  end

  describe '#release_bike' do
    it 'releases a working bike' do
      bike = double(:working? => true)
      subject.dock(bike)
      expect(subject.release_bike).to be_working
    end
    context 'docking station empty' do
      it 'raises an error' do
        expect{subject.release_bike}.to raise_error "No bikes available"
      end
    end
    context 'broken bike' do
      it 'is not released' do
        allow(bike).to receive(:working?).and_return(true)
        allow(bike).to receive(:broken).and_return(bike)
        5.times { subject.dock bike }
        expect(subject.release_bike).to be_working
      end
      it 'raises an error when all bikes are broken' do
        allow(bike).to receive(:broken).and_return(bike)
        allow(bike).to receive(:working?).and_return(false)
        5.times do
          subject.dock(bike.broken)
        end
        expect{subject.release_bike}.to raise_error "No bikes available"
      end
    end
  end

  describe '#dock' do
    it 'shows the user the docked bike' do
      subject.dock(bike)
      expect(subject.bikes).to include bike
    end

    context 'docking station is full' do
      it 'raises an error' do
        DockingStation::DEFAULT_CAPACITY.times { subject.dock(bike) }
        expect{ subject.dock(bike) }.to raise_error "Docking station full"
      end
    end

    context 'a broken bike' do
      it 'can be reported' do
        allow(bike).to receive(:broken).and_return(bike)
        allow(bike).to receive(:working?).and_return(false)
        expect(bike).not_to be_working
      end
      it 'can be docked' do
        allow(bike).to receive(:broken).and_return(bike)
        allow(bike).to receive(:working?).and_return(false)
        subject.dock(bike.broken)
        expect(subject.bikes).to include bike
      end
    end

  describe '#remove_broken_bikes' do
      it 'removes broken bikes' do
        allow(bike).to receive(:working?).and_return(true)
        subject.dock(bike)
        3.times { subject.dock(Bike.new.broken) }
        broken_bikes = subject.remove_broken_bikes
        expect(subject.bikes).not_to include broken_bikes
      end
    end
  end
end
