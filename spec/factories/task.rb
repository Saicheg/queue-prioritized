require 'factory_girl'

FactoryGirl.define do
  factory :task do
    description 'foobar'
    finish_time Time.now
  end
end
