require 'spec_helper'
require './lib/exams_parser'

describe ExamsParser do
  context '#exams', :vcr, :slow => true do
    it 'should run without raising an exception' do
      ExamsParser.stubs(:get_teacher_name).returns("foo")
      ExamsParser.stubs(:get_modul_label).returns("foo")
      -> { ExamsParser.run }.should_not raise_error
    end
    it 'should call save on the new instances' do
      Exam.any_instance.expects(:save).at_least_once
      ExamsParser.run
    end
  end
end
