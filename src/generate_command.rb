gem 'icalendar'

require 'icalendar'
require 'time'

require_relative 'command'
require_relative 'store'
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
    store = Store.new
    @sources.each do |src|
      src += '.m' if src !~ /\.m$/
      raise "No '#{src}' file?!" if !store.exist? src
      cal = store.retrieve_calendar src
      cal.events.collect do |e|
        all_events << {cal: cal, event: e}
      end
    end
    all_events.sort! { |a, b| a[:event] <=> b[:event] }
    ical = Icalendar::Calendar.new
    ical.publish
    all_events.each do |p|
      e = p[:event]
      ical.event do |ie|
        ie.uid         = "#{p[:cal].name}-#{e.id}@calfeed.barneyb.com"
        ie.sequence    = e.seq
        ie.dtstart     = Icalendar::Values::DateTime.new(e.start_time.new_offset('-00:00'))
        ie.dtend       = Icalendar::Values::DateTime.new(e.end_time.new_offset('-00:00'))
        ie.summary     = e.title
        ie.description = e.notes
        ie.location    = e.location
      end
    end
    File.open(@filename, 'w') { |io| io.puts ical.to_ical }
    puts "Generated #{all_events.size} events"
  end
end
