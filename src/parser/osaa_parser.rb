require 'csv'
require 'date'

require_relative '../model/event'

EVENT_LENGTH = Rational(1, 24) # one hour, in days

class OsaaParser

  attr_accessor :team_name, :time_zone

  def initialize(args)
    @team_name, @time_zone = args
    @time_zone = Time.now.getlocal.zone if !@time_zone
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
      ds = fields['Date'] + ' ' + fields['Time'] + ' ' + @time_zone
      e.start_time = begin
                       DateTime.strptime(
                         ds,
                         '%m/%d/%y ' + (atHour ? '%I%p' : '%I:%M%p') + ' %z'
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
