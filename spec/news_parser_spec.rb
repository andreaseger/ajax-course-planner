require "spec_helper"
require './lib/news_parser.rb'

describe NewsParser do
  context '#bookings', :vcr, :slow => true do
    it 'should run without raising an exception' do
      NewsParser.stubs(:get_person_name).returns("foo")
      -> { NewsParser.run }.should_not raise_error
    end
    it 'should call save on the new instances' do
      News.any_instance.expects(:save).at_least_once
      NewsParser.run
    end
  end
end
