require 'spec_helper'
require_relative '../lib/exam'

describe Exam do
  let(:data) do
    {
      course: { name: 'webengineering', label: 'Web Engineering' },
      examiner: [ { name: 'hofhansjoachim', label: 'Hof Hans-Joachim' }, { name: 'schiedermeierreinhard', label: 'Schiedermeier Reinhard' } ],
      room: [{ name: 'r0007', label: 'R0.007', building: 'r', floor: 0 }],
      time: Time.now,
      material: 'nix',
      type: 'sp90'
    }
  end
  let(:json) { data.to_json }
  let(:exam) { Exam.from_hash data }

  context '#to_json' do
    it 'should be equal to the source data' do
      exam.to_json.should eq(json)
    end
  end
  context '#from_json' do
    context '#time' do
      it 'should create a new exam object with time data' do
        exam.should have_key(:time)
      end
      it "should be a Time object" do
        exam[:time].should be_a(Time)
      end
    end
    context '#course' do
      it 'should create a new exam object with course data' do
        exam.should have_key(:course)
      end
      [ :name, :label ].each do |key|
        it "should have a #{key}" do
          exam[:course].should have_key(key)
        end
      end
    end
    context '#room' do
      it 'should create a new exam object with room data' do
        exam.should have_key(:room)
      end
      it 'should be a array of rooms' do
        exam[:room].should be_a(Array)
      end
      [ :name, :label, :building, :floor ].each do |key|
        it "should have a #{key}" do
          exam[:room].first.should have_key(key)
        end
      end
    end
    context '#examiner' do
      it 'should create a new exam object with examiner data' do
        exam.should have_key(:examiner)
      end
      it 'should be a array of examiner' do
        exam[:examiner].should be_a_kind_of(Array)
      end
      [ :name, :label ].each do |key|
        it "should have a #{key}" do
          exam[:examiner].first.should have_key(key)
        end
      end
    end
    context '#material' do
      it 'should create a new exam object with material data' do
        exam.should have_key(:material)
      end
    end
    context '#type' do
      it 'should create a new exam object with type data' do
        exam.should have_key(:type)
      end
    end
  end
  context '#key' do
    it 'should create the same key if the data is the same' do
      exam.key.should == Exam.from_hash(data).key
    end
    it 'should deliver different keys for different data' do
      other_exam = Exam.from_hash(data.merge(group: {name: 'foo'}))
      exam.key.should_not == other_exam.key
    end
  end
end
