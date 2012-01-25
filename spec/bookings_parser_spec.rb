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
end
