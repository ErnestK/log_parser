# frozen_string_literal: true

require_relative '../../models/log.rb'
require_relative 'redis_api.rb'

module Repositories
  module Redis
    # Redis repo impl which implement all repo methods
    class Logger < RedisApi
      include ::Repositories::LoggerRepository

      def error(str)
        @db.rpush(error_collection_name, str)
      end

      def error_exists?
        @db.llen(error_collection_name) != 0
      end

      def info(str)
        @db.rpush(info_collection_name, str)
      end

      def all_errors
        @db.lrange(error_collection_name, 0, -1).map do |data|
          log = Models::Log.new
          log.data = data

          log
        end
      end

      def all_info
        @db.lrange(info_collection_name, 0, -1).map do |data|
          log = Models::Log.new
          log.data = data

          log
        end
      end

      private

      def info_collection_name
        'list:info:log'
      end

      def error_collection_name
        'list:error:log'
      end
    end
  end
end
