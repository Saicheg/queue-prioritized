require_relative 'spec_helper'

describe Task do

  describe 'iniitialization' do

    it 'should create valid task object' do
      expect { Task.new(finish_time: Time.now, description: 'foo') }.to_not raise_error
    end

    it 'should filter invalid param sex on initialize' do
      expect { Task.new(finish_time: Time.now, description: 'foo', sex: 'bar') }.to raise_error
    end

    it 'should be fine if only 1 argument is passed' do
      expect { Task.new(description: 'foo') }.to_not raise_error
    end

  end

  describe 'behaviour' do
    context 'user is trying to pass invalid type arguments' do
      subject { Task.new }

      it 'should not allow string format for finish_time param' do
        expect { subject.finish_time = 'foobar' }.to raise_error
      end

      it 'should allow time format for finish_time param' do
        expect { subject.finish_time = Time.now }.to_not raise_error
      end

      it 'should not allow other format either string for descrption param' do
        expect { subject.description = 42 }.to raise_error
      end

      it 'should allow string format for description param' do
        expect { subject.description = 'foobar' }.to_not raise_error
      end
    end
  end

  describe 'serialization/deserialization' do
    subject { Task.new(finish_time: Time.now, description: 'foo') }

    it 'should be serialized to json' do
      subject.to_json.should == {finish_time: subject.finish_time, description: subject.description}.to_json
    end

    it 'should be successfully deserialized from json' do
      json = subject.to_json
      Task.parse(json).class.should == Task
    end
  end

end
