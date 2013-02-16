FactoryGirl.define do
  factory :task do
    description 'foobar'
    finish_time Time.now
  end

  factory :future_task, class: Task do
    description 'future'
    finish_time Time.now + 2*7*24*60*60 # 2 weeks
  end

  factory :expired_task, class: Task do
    description 'expired'
    finish_time Time.now - 2*7*24*60*60 # 2 weeks
  end
end
