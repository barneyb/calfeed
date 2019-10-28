gem 'icalendar'

require 'icalendar'
require 'time'

require_relative 'command'
require_relative 'model/calendar'
require_relative 'model/event'

class GenerateCommand < Command
  def initialize(params)
    @filename = params[0]
    @sources = params.slice(1, 1000)
  end

  def run
    puts "generate '#{@filename}' from #{@sources}"
    all_events = []
    @sources.each do |src|
      src += '.m' if src !~ /\.m$/
      raise "No '#{src}' file?!" if !File.exist? src
      cal = File.open(src) { |io| Marshal.load io }
      all_events.concat cal.events
    end
    all_events.sort!
    ical = Icalendar::Calendar.new
    all_events.each do |e|
      ical.event do |ie|
        ie.uid         = e.id.to_s
        ie.sequence    = e.seq
        ie.dtstart     = Icalendar::Values::DateTime.new(e.start_time)
        ie.dtend       = Icalendar::Values::DateTime.new(e.end_time)
        ie.summary     = e.title
        ie.description = e.notes
        ie.location    = e.location
      end
    end
    ical.publish
    File.open(@filename, 'w') { |io| io.puts ical.to_ical }
  end

end
