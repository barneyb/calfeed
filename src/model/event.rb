class Event

  attr_reader :start_time, :end_time
  attr_accessor :id, :seq, :title, :location, :notes

  def initialize id
    @id = id
    @seq = 1
  end

  def duration
    # minus gives a float, we want an integral
    (end_time - start_time).to_i
  end

  def start_time= time
    @start_time = clean_time time
  end

  def end_time= time
    @end_time = clean_time time
  end

  def <=> other
    c = start_time <=> other.start_time
    c = id <=> other.id if c == 0
    c
  end

  def to_s
    "#{title} [#{Time.at(start_time).localtime} for #{duration}s]"
  end

  private def clean_time time
    return time if time.utc?
    Time.at(time).utc
  end

end
