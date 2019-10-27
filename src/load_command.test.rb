require 'minitest/autorun'
require_relative 'load_command'

class LoadCommandTest < Minitest::Test

  def test_for_smoke
    LoadCommand.new ["osaa", "osaa.txt"]
  end

end
