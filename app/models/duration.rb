class Duration
  def initialize(string)
    @seconds, minutes, hours, *rest = string.split(':').map(&:to_i).reverse
    minutes +=   hours * 60 if hours
    @seconds += minutes * 60 if minutes

    raise DurationParseError.new(string) if rest.any?
  end

  def in_seconds
    @seconds
  end

  def to_i
    @seconds
  end

  def to_s
    @seconds.to_s
  end
end

class DurationParseError < Exception
  attr_reader :string, :message
  def initialize(string)
    @string = string
    @message = "Could not parse #{string}"
  end
end
