require File.expand_path('../spec_helper', __FILE__)

describe Queue do

  subject            { Queue.new }
  let(:task)         { FactoryGirl.build(:task) }
  let(:expired_task) { FactoryGirl.build(:expired_task) }

  describe '#push' do

    it 'should push new task correct' do
      subject.push(task).should be_true
    end

    it 'should not be able to add two absolutely same tasks' do
      subject.push(task)
      subject.push(task).should be_false
    end

  end

  describe '#pop' do
    let(:future_task)  { FactoryGirl.build(:future_task) }

    it 'should return nil if no items in queue' do
      subject.pop.should be_nil
    end

    it 'should return object of Task class' do
      subject.push(task)
      subject.pop.class.should == Task
    end

    it 'should pop expired task first' do
      subject.push(task)
      subject.push(expired_task)
      subject.pop.description.should == expired_task.description
    end

    it 'should return closest task first' do
      subject.push(future_task)
      subject.push(task)
      subject.pop.description.should == task.description
    end

  end

  describe '#get_task' do
    let(:time) { task.finish_time }

    it 'should return nil if no items in queue' do
      subject.get_task(time).should be_nil
    end

    it 'should return object of Task class' do
      subject.push(task)
      subject.get_task(time).class.should == Task
    end

    it 'should return finded task' do
      subject.push(task)
      subject.get_task(time).description.should == task.description
    end

    it 'should remove task from queue if its finded' do
      subject.push(task)
      subject.get_task(time)
      subject.get_task(time).should be_nil
    end

    it 'should return nil if task is not finded' do
      subject.get_task(time).should be_nil
    end

  end

end
