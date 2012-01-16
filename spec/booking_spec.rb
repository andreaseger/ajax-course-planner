require 'spec_helper'
require_relative '../lib/booking'

describe Booking do
  let(:data) do
    {
      timeslot: { start_minute: 0, start_hour: 10, end_minute: 30, end_hour: 11 },
      room: { name: 'r0007', label: 'R0.007', building: 'r', floor: 0 },
      group: { name: 'IG' },
      course: { name: 'webengineering', label: 'Web Engineering' },
      teachers: [ { name: 'hofhansjoachim', label: 'Hof Hans-Joachim' }, { name: 'schiedermeierreinhard', label: 'Schiedermeier Reinhard' } ]
    }
  end
  let(:json) { data.to_json }
  let(:booking) { Booking.from_json json }

  context '#to_json' do
    it 'should be equal to the source data' do
      booking.to_json.should eq(json)
    end
  end
  context '#from_json' do
    it 'should create a new booking object with timeslot data' do
      booking.should have_key(:timeslot)
    end
    context '#timeslot' do
      [ :start_minute, :start_hour, :end_hour, :end_minute ].each do |key|
        it "should have a #{key}" do
          booking[:timeslot].should have_key(key)
        end
      end
    end
    it 'should create a new booking object with room data' do
      booking.should have_key(:room)
    end
    context '#room' do
      [ :name, :label, :building, :floor ].each do |key|
        it "should have a #{key}" do
          booking[:room].should have_key(key)
        end
      end
    end
    it 'should create a new booking object with group data' do
      booking.should have_key(:group)
    end
    context '#group' do
      [ :name ].each do |key|
        it "should have a #{key}" do
          booking[:room].should have_key(key)
        end
      end
    end
    it 'should create a new booking object with course data' do
      booking.should have_key(:course)
    end
    context '#course' do
      [ :name, :label ].each do |key|
        it "should have a #{key}" do
          booking[:course].should have_key(key)
        end
      end
    end
    it 'should create a new booking object with teachers data' do
      booking.should have_key(:teachers)
    end
    context '#teachers' do
      it 'should be a array of teachers' do
        booking[:teachers].should be_a_kind_of(Array)
      end
      [ :name, :label ].each do |key|
        it "should have a #{key}" do
          booking[:teachers].first.should have_key(key)
        end
      end
    end
  end

  context '#key' do
    it 'should provide a string with 3 characters' do
      booking.key.should have(3).characters
    end
    it 'should create the same key if the data is the same' do
      booking.key.should == Booking.from_json(json).key
    end
    it 'should deliver different keys for different data' do
      other_booking = Booking.from_json(data.merge(group: {name: 'foo'}).to_json)
      booking.key.should_not == other_booking.key
    end
  end
end
