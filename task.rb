require 'time'
require 'json'

class Task

  ATTRIBUTES = :finish_time, :description

  attr_reader *ATTRIBUTES

  def self.parse(data)
    return nil unless data
    attrs = JSON.parse(data)
    self.new finish_time: Time.parse(attrs['finish_time']),
             description: attrs['description']
  end

  def initialize(params={})
    raise ArgumentError unless valid_attributes?(params.keys)
    params.each { |value, key| send("#{value}=", key) }
  end

  def finish_time=(attr)
    raise ArgumentError unless attr.is_a?(Time)
    @finish_time = attr
  end

  def description=(attr)
    raise ArgumentError unless attr.is_a?(String)
    @description = attr
  end

  def to_json
    Hash[ATTRIBUTES.map {|attr| [attr, send(attr)]}].to_json
  end

  private

  def valid_attributes?(attrs)
    (ATTRIBUTES | attrs) == ATTRIBUTES
  end

end
