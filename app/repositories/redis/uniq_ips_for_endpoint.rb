# frozen_string_literal: true

require_relative '../uniq_ips_for_endpoint_repository.rb'

module Repositories
  module Redis
    # Redis repo impl which implement all repo methods
    # we could create one impl for all repo, but in this way its better to read, maintain..
    class UniqIpsForEndpoint < RedisApi
      include ::Repositories::UniqIpsForEndpointRepository

      def not_exist?(endpoint, ip)
        !@db.sismember(collection_name(endpoint), ip)
      end

      def add(endpoint, ip)
        @db.sadd(collection_name(endpoint), ip)
      end

      private

      def collection_name(endpoint)
        "set:#{endpoint}"
      end
    end
  end
end
