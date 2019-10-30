require 'date'
require 'nokogiri'

require_relative '../model/event'

EVENT_LENGTH = Rational(1, 24) # one hour, in days

# fields/columns
DATE      = 2
TIME      = 3
HOME_AWAY = 4
OPPONENT  = 5
FIELD     = 7

class TsssParser

  attr_accessor :time_zone

  def initialize(args)
    @time_zone = args[0] if args and args.size > 0
    @time_zone = Time.now.getlocal.zone if !@time_zone
  end

  def parse(io)
    html = io.gets nil
    doc = Nokogiri::HTML.parse html
    i = 0
    doc.css(".itemlist")[1].css(".tritem, .trodditem").collect do |it|
      i += 1
      fields = it.css ".tditem"
      e = Event.new i
      prefix = case fields[HOME_AWAY].text.strip
                 when 'A' then '@'
                 when 'H' then 'vs '
               end
      e.title = prefix + fields[OPPONENT].text
      e.start_time = DateTime.parse(fields[DATE].text + ' ' + fields[TIME].text + ' ' + @time_zone)
      e.end_time = e.start_time + EVENT_LENGTH
      e.location = fields[FIELD].text
      e
    end
  end
end
