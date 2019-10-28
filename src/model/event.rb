class Event

  attr_accessor :id, :seq, :title, :start_time, :end_time, :location, :notes

  def initialize(id)
    @id = id
    @seq = 1
  end

  def duration
    # minus gives days; we want seconds
    ((end_time - start_time) * 24 * 60 * 60).to_i
  end

  def <=>(other)
    c = start_time <=> other.start_time
    c = id <=> other.id if c == 0
    c
  end

  def to_s
    "#{title} [#{start_time} for #{duration}s]"
  end

end
