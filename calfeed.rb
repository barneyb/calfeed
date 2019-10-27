#!/usr/bin/env ruby

def get_command()
  cmd, *rest = ARGV
  case cmd
    when 'load'
      require_relative 'src/load_command'
      LoadCommand.new(rest)
    when 'generate'
      require_relative 'src/generate_command'
      GenerateCommand.new(rest)
    else
      puts "Unknown command: '#{cmd}'"
      puts "Available commands: load, generate"
      exit 1
  end
end

get_command().run
