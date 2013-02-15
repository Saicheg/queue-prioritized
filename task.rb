class Task

  ATTRIBUTES = :finish_time, :description

  attr_reader *ATTRIBUTES

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

  private

  def valid_attributes?(attrs)
    (ATTRIBUTES | attrs) == ATTRIBUTES
  end

end
