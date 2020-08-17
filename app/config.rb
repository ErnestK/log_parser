# frozen_string_literal: true

require 'redis'

# Class which contain all main configs how our app works
# which db connection, printers.. we can use
# we create it only one time
class Config
  attr_reader :redis, :printer

  def initialize
    @redis = Redis.new(host: ENV['REDIS_HOST'])
    @printer = Printers::Stdout.new
  end
end
