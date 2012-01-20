require 'spec_helper'
require './lib/parser'

describe Parser do
  let(:parser) { Parser.new }

  context '#course', :vcr do
    it 'should have a method "get_modul_label"' do
      parser.should respond_to(:get_modul_label)
    end
    { 'ereignisgesteuertesysteme' => "Ereignisgesteuerte Systeme",
      'anwendungsentwicklungmitchipkarten' => "Anwendungsentwicklung mit Chipkarten" }.each do |k,v|
      it "should get the label for #{k}" do
        parser.get_modul_label(k).should == v
      end
    end
  end
  context '#people', :vcr do
    it 'should have a method "get_person_name"' do
      parser.should respond_to(:get_person_name)
    end

    { 'eichsoellneredda' => "Prof. Dr. Edda Eich-Soellner",
      'kailerdaniel' => "Daniel Kailer" }.each do |k,v|
      it "should get the full name for #{k}" do
        parser.get_person_name(k).should == v
      end
    end
  end
end
