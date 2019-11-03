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
    doc.css(".itemlist")[1].css(".tritem, .trodditem").collect do |it|
      i += 1
      fields = it.css ".tditem"
      e = Event.new i
      prefix = case fields[HOME_AWAY].text.strip
                 when 'A' then '@'
                 when 'H' then 'vs '
               end
      e.title = prefix + fields[OPPONENT].text
      ts = Time.parse(fields[DATE].text + ' ' + fields[TIME].text)
      e.start_time = TZInfo::Timezone.get(config.time_zone).local_to_utc(ts)
      e.end_time = e.start_time + EVENT_LENGTH
      e.location = fields[FIELD].text
      e
    end
  end
end
