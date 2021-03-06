require 'json'
require 'redis'
require 'securerandom'
require 'pry'

class Queue

  def initialize
    @redis = Redis.new
    @mutex = Mutex.new
  end

  def push(task)
    @mutex.synchronize { add_to_queue(task) }
  end

  def pop
    @mutex.synchronize do
      return nil if empty_queue?
      return_task(closest)
    end
  end

  def get_task(finish_time)
    @mutex.synchronize do
      return nil if empty_queue?
      return_task expired || find_by_key(finish_time.to_i).last
    end
  end

  protected

  def return_task(task)
    remove_from_redis(task)
    Task.parse(task)
  end

  def remove_from_redis(task)
    @redis.zrem(redis_key, task)
  end

  def closest
    @redis.zrevrange(redis_key, 0, max_index).last
  end

  def expired
    @redis.zrangebyscore(redis_key, 0, Time.now.to_i).first
  end

  def max_index
    @redis.zcard(redis_key)
  end

  def add_to_queue(task)
    @redis.zadd(redis_key, task.finish_time.to_i, task.to_json)
  end

  def find_by_key(key)
    @redis.zrevrangebyscore(redis_key, key, key)
  end

  def empty_queue?
    max_index == 0
  end

  def redis_key
    @redis_key ||= "queue-#{SecureRandom.hex}-#{Time.now.to_i}"
  end

end
