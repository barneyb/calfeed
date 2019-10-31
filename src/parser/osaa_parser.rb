require 'csv'
require 'time'

require_relative '../model/event'

EVENT_LENGTH = 3600 # one hour, in seconds

class OsaaParser

  attr_accessor :team_name

  def initialize(args)
    @team_name = args[0] if args && args.size > 0
  end

  def parse(io)
    csv = CSV.new(io, headers: true)
    csv.collect do |row|
      fields = row.to_h
      e = Event.new fields['Contest ID'] 
      e.title = if fields['Home Team'] == @team_name
                  "vs #{fields['Away Team']}"
                elsif fields['Away Team'] == @team_name
                  "@#{fields['Home Team']}"
                else
                  "#{fields['Home Team']} vs #{fields['Away Team']}"
                end
      atHour = true
      ds = fields['Date'] + ' ' + fields['Time']
      e.start_time = begin
                       Time.strptime(
                         ds,
                         '%m/%d/%y ' + (atHour ? '%I%p' : '%I:%M%p')
                       )
                     rescue ArgumentError
                       if atHour then
                         atHour = false
                         retry
                       else
                         raise
                       end
                     end
      e.end_time = e.start_time + EVENT_LENGTH
      e.location = fields['Location']
      e
    end
  end
end
