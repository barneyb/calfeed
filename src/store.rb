class Store

  def exist?(key)
    File.exist? get_filename(key)
  end

  def store_calendar(key, cal)
    File.open(get_filename(key), 'w') { |io| Marshal.dump cal, io }
    nil
  end

  def retrieve_calendar(key)
     File.open(get_filename(key)) { |io| Marshal.load io }
  end

  private def get_filename(key) 
    if key =~ /\.m$/
      key
    else
      key + '.m'
    end
  end

end
