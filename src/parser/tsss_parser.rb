require 'nokogiri'
require 'time'
require 'tzinfo'

require_relative '../config'
require_relative '../model/event'

EVENT_LENGTH = 3600 # one hour, in seconds

# fields/columns
DATE      = 2
TIME      = 3
HOME_AWAY = 4
OPPONENT  = 5
FIELD     = 7

class TsssParser

  def initialize(args)
  end

  def parse(io)
    config = Config.instance
    html = io.gets nil
    doc = Nokogiri::HTML.parse html
    i = 0
    events = []
    sched = doc.css(".itemlist")
    return events if sched == nil || sched.size < 2
    sched[1].css(".tritem, .trodditem").each do |it|
      i += 1
      fields = it.css ".tditem"
      e = Event.new i
      prefix = case fields[HOME_AWAY].text.strip
                 when 'A' then '@'
                 when 'H' then 'vs '
               end
      e.title = prefix + fields[OPPONENT].text
      begin
        ts = Time.parse(fields[DATE].text + ' ' + fields[TIME].text)
      rescue ArgumentError
        next
      end
      e.start_time = TZInfo::Timezone.get(config.time_zone).local_to_utc(ts)
      e.end_time = e.start_time + EVENT_LENGTH
      e.location = fields[FIELD].text
      events << e
    end
    events
  end
end
