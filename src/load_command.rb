require_relative 'command'
require_relative 'model/calendar'

def get_parser(name, args)
  case name
    when 'osaa'
      require_relative 'parser/osaa_parser'
      OsaaParser.new
    when 'tsss'
      require_relative 'parser/tsss_parser'
      p = TsssParser.new
      p.time_zone = args[0] if args and !args.empty?
      p
    else
      puts "Unknown source format: '#{name}'"
      puts "Available formats: osaa, tsss"
      exit 1
  end
end

class LoadCommand < Command
  def initialize(params)
    @parser = get_parser(params[0], params.slice(2))
    @filename = params[1]
  end

  def run
    puts "loading '#{@filename}' (with #{@parser})"
    events = File.open(@filename) do |io|
      @parser.parse(io)
    end
    cal = Calendar.new @filename, events
    cache_file = @filename + '.m'
    if File.exist? cache_file
      # see if we need to update seq
      old_cal = File.open(cache_file) { |io| Marshal.load io }
      cal.events.each do |e|
        old_e = old_cal.events.find { |it| it.id == e.id }
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
    File.open(cache_file, 'w') { |io| Marshal.dump cal, io }
    puts cal
  end

end
