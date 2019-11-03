require 'singleton'
require 'tzinfo'
require 'yaml'

# Well this is a mess. :) But it does work!
class Config
  include Singleton
  attr_accessor :time_zone

  def initialize
    @time_zone = TZInfo::Timezone.get("UTC")
    overlay_local_config
  end

  def overlay_local_config
    path = File.join(Dir.pwd, '.calfeed')
    return if !File.exist? path
    config = File.open(path) do |io|
      content = io.gets(nil)
      begin
        YAML.load content
      rescue
        puts "Malformed config in '#{path}'"
        nil
      end
    end
    merge config
  end

  private def merge config
    return if !config
    @time_zone = config["time_zone"] if config.has_key? 'time_zone'
  end

end
