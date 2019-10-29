require 'forwardable'

class Calendar
  extend Forwardable
  include Enumerable

  attr_accessor :name
  def_delegators :@events, :size, :each

  def initialize(name, events=[])
    @name = name
    @events = events
    @byId = Hash.new
  end

  def <<(event)
    @events << event
    @byId[event.id] = event
  end

  def get_event(id)
    @byId[id]
  end

  def to_s
    "#{name} (#{size} events) #{@events.find do |it|
      it.start_time > DateTime.now
    end}"
  end

  def marshal_dump
    [@name, @events]
  end

  def marshal_load array
    @name, @events = array
    @byId = Hash.new
    @events.each { |e| @byId[e.id] = e }
  end

end
