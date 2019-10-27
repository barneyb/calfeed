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
    puts "All Events:"
    all_events.each { |e| puts e }
  end

end
