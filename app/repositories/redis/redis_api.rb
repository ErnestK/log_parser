# frozen_string_literal: true

require 'redis'

module Repositories
  module Redis
    # main class/parent for all redis repo impl
    # have constructor which get db connection to redis
    # and method to flush all db after script exit
    class RedisApi
      def initialize(db)
        @db = db
      end

      def flush
        @db.flushall
      end
    end
  end
end
