require "spec_helper"
require './lib/bookings_parser.rb'

describe BookingsParser do
  context '#bookings', :vcr, :slow => true do
    it 'should run without raising an exception' do
      BookingsParser.stubs(:get_person_name).returns("foo")
      BookingsParser.stubs(:get_modul_label).returns("foo")
      -> { BookingsParser.run }.should_not raise_error
    end
    it 'should call save on the new instances' do
      Booking.any_instance.expects(:save).at_least_once
      BookingsParser.run
    end
  end
  context 'merge_similar' do
    let(:timeslot) do
        {
          label: "08:15",
          start_minute: 15,
          start_hour: 8,
          length: 90,
          day: { name: "fr", label: "Freitag"}
        }
    end
    let(:room) do
      { name: 'r0007', label: 'R0.007', building: 'r', floor: 0 }
    end
    let(:alt_room) do
      {name: 'r3007', label: 'R3.007', building: 'r', floor: 3 }
    end
    let(:group) do
      { name: 'IG' }
    end
    let(:course) do
      { label: 'Happy Hacking' }
    end
    let(:teacher) do
      { name: 'bar' }
    end
    let(:booking) do
      Booking.from_hash ({
                          timeslot: timeslot,
                          rooms: [room],
                          group: group,
                          course: course,
                          teacher: teacher
                        })
    end
    let(:alt_booking) do
      Booking.from_hash ({
                          timeslot: timeslot,
                          rooms: [alt_room],
                          group: group,
                          course: course,
                          teacher: teacher
                        })
    end
    let(:parser) { BookingsParser.new }

    it "should do nothing if no bookings are there" do
      parser.all_bookings = []
      parser.merge_similar
      parser.all_bookings.should be_empty
    end
    it "should do nothing if all bookings are unique" do
      all_bookings = [ booking, booking.merge(course: {label: "foo"}) ]
      parser.all_bookings = all_bookings
      parser.merge_similar
      parser.all_bookings.should eq(all_bookings)
    end
    it "should merge the rooms for similar bookings" do
      all_bookings = [ booking, alt_booking ]
      parser.all_bookings = all_bookings
      parser.merge_similar
      parser.all_bookings.should have(1).thing
      rooms = parser.all_bookings[0][:rooms]
      rooms.should have(2).things
    end
    it "should not change the individual rooms when merging" do
      all_bookings = [ booking, alt_booking ]
      parser.all_bookings = all_bookings
      parser.merge_similar
      rooms = parser.all_bookings[0][:rooms]
      rooms.should include(room, alt_room)
    end
  end
end
