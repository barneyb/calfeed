class Calendar

  attr_accessor :name, :events

  def initialize(name, events)
    @name = name
    @events = events
  end

  def to_s
    "#{name} (#{events.size} events) #{events.find do |it|
      it.start_time > DateTime.now
    end}"
  end

end
