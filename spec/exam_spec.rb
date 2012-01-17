require 'spec_helper'
require_relative '../lib/exam'

describe Exam do
  let(:data) do
    {
      course: { name: 'webengineering', label: 'Web Engineering' },
      examiner: [ { name: 'hofhansjoachim', label: 'Hof Hans-Joachim' }, { name: 'schiedermeierreinhard', label: 'Schiedermeier Reinhard' } ],
      room: { name: 'r0007', label: 'R0.007', building: 'r', floor: 0 },
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

  end
end
