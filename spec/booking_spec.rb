require 'spec_helper'
require_relative '../lib/booking'

describe Booking do
  let(:data) do
    {
      timeslot: { start_minute: 0, start_hour: 10, end_minute: 30, end_hour: 11 },
      rooms: [{ name: 'r0007', label: 'R0.007', building: 'r', floor: 0 }],
      group: { name: 'IG' },
      course: { name: 'webengineering', label: 'Web Engineering' },
      people: [ { name: 'hofhansjoachim', label: 'Hof Hans-Joachim' }, { name: 'schiedermeierreinhard', label: 'Schiedermeier Reinhard' } ],
      teacher: { name: 'orehekmartin', label: 'Prof. Dr.-Ing. Martin Orehek'},
      suffix: "Embedded Systems"
    }
  end
  let(:json) { data.to_json }
  let(:booking) { Booking.from_hash data }

  context '#to_json' do
    it 'should be equal to the source data' do
      booking.to_json.should eq(json)
    end
  end
  context '#from_json' do
    context '#timeslot' do
      it 'should create a new booking object with timeslot data' do
        booking.should have_key(:timeslot)
      end
      [ :start_minute, :start_hour, :end_hour, :end_minute ].each do |key|
        it "should have a #{key}" do
          booking[:timeslot].should have_key(key)
        end
      end
    end
    context '#rooms' do
      it 'should create a new booking object with room data' do
        booking.should have_key(:rooms)
      end
      [ :name, :label, :building, :floor ].each do |key|
        it "should have a #{key}" do
          booking[:rooms][0].should have_key(key)
        end
      end
    end
    context '#group' do
      it 'should create a new booking object with group data' do
        booking.should have_key(:group)
      end
      [ :name ].each do |key|
        it "should have a #{key}" do
          booking[:group].should have_key(key)
        end
      end
    end
    context '#course' do
      it 'should create a new booking object with course data' do
        booking.should have_key(:course)
      end
      [ :name, :label ].each do |key|
        it "should have a #{key}" do
          booking[:course].should have_key(key)
        end
      end
    end
    context '#people' do
      it 'should create a new booking object with teachers data' do
        booking.should have_key(:people)
      end
      it 'should be a array of teachers' do
        booking[:people].should be_a_kind_of(Array)
      end
      [ :name, :label ].each do |key|
        it "should have a #{key}" do
          booking[:people].first.should have_key(key)
        end
      end
    end
  end

  context '#key' do
    it 'should create the same key if the data is the same' do
      booking.key.should == Booking.from_hash(data).key
    end
    it 'should deliver different keys for different data' do
      other_booking = Booking.from_hash(data.merge(group: {name: 'foo'}))
      booking.key.should_not == other_booking.key
    end
  end
  context '#similar?' do
    let(:data) do
      {
        timeslot: {
          label: "08:15",
          start_minute: 15,
          start_hour: 8,
          length: 90,
          day: { name: "fr", label: "Freitag"}
        },
        rooms: [{ name: 'r0007', label: 'R0.007', building: 'r', floor: 0 }],
        group: { name: 'IG' },
        course: { label: 'Happy Hacking' },
        teacher: { name: 'bar' },
      }
    end
    let(:booking) { Booking.from_hash(data) }
    it "should be true if the bookings are equal" do
      booking.similar?(booking).should be_true
    end
    it "should be true if only the room is different" do
      similar_booking = Booking.from_hash(data.merge(rooms: [{ name: 'r3007', label: 'R3.007', building: 'r', floor: 3 }]))
      booking.similar?(similar_booking).should be_true
    end
    it "should be false if the timeslot is different" do
      similar_booking = Booking.from_hash(data.merge(timeslot: { label: "foo" }))
      booking.similar?(similar_booking).should be_false
    end
  end
end
