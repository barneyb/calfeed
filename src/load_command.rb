require_relative 'command'
require_relative 'store'
require_relative 'model/calendar'

def get_parser(name, args)
  case name.downcase
    when 'osaa'
      require_relative 'parser/osaa_parser'
      OsaaParser.new args
    when 'tsss'
      require_relative 'parser/tsss_parser'
      TsssParser.new args
    when 'ical', 'ics', 'icalendar'
      require_relative 'parser/ical_parser'
      ICalParser.new args
    else
      puts "Unknown source format: '#{name}'"
      puts "Available formats: osaa, tsss"
      exit 1
  end
end

class LoadCommand < Command
  def initialize(params)
    @parser = get_parser(params[0], params.slice(2, params.size))
    @filename = params[1]
  end

  def run
    puts "loading '#{@filename}' (with #{@parser})"
    events = File.open(@filename) do |io|
      @parser.parse(io)
    end
    cal = Calendar.new @filename, events
    store = Store.new
    if store.exist? @filename
      # see if we need to update seq
      old_cal = store.retrieve_calendar @filename
      cal.each do |e|
        old_e = old_cal.get_event e.id
        next if !old_e
        e.seq = old_e.seq
        [:title, :start_time, :end_time, :location, :notes].each do |prop|
          if e.send(prop) != old_e.send(prop)
            puts "Event #{e.id} had its '#{prop}' prop updated"
            e.seq += 1
            break
          end
        end
      end
    end
    store.store_calendar @filename, cal
    puts cal
  end

end
