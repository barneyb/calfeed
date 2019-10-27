class Event

  attr_accessor :id, :seq, :title, :start_time, :end_time, :location, :notes

  def initialize(id)
    @id = id
    @seq = 1
  end

  def duration
    (end_time - start_time).to_i
  end

  def to_s
    "#{title} [#{start_time} for #{duration}s]"
  end

end
