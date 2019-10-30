gem 'icalendar'

require 'icalendar'
require 'date'
require 'digest'

require_relative '../model/event'

class ICalParser

  def initialize(args)
    @cal_idx = args[0] if args and args.size > 0
    @cal_idx = 0 if !@cal_idx
  end

  def parse(io)
    ical = Icalendar::Calendar.parse(io)[@cal_idx]
    ical.events.collect do |ie|
      e = Event.new Digest::SHA1.hexdigest(ie.uid)
      e.seq        = ie.sequence
      e.title      = ie.summary
      e.start_time = ie.dtstart.value
      e.end_time   = ie.dtend.value
      e.notes      = ie.description
      e.location   = ie.location
      e
    end
  end
end
