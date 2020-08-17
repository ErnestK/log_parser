# frozen_string_literal: true

require 'dry/monads'

module Services
  # All services should be act as monads, and have only one public method call
  # which return Success or Failure
  # Class which counts visits on endpoint by api,
  # counts as uniq ip as all visits
  # and persisit it in db, without knowledge which db,
  # cause use repositories
  class CountVisits
    include Dry::Monads[:result]

    def initialize(config)
      @config = config
    end

    def call(endpoint:, ip:)
      # In real apps we should add transaction here
      # but we have ruby script, and if it fails we flush db and run again
      if Repositories::Redis::UniqIpsForEndpoint.new(@config.redis).not_exist?(endpoint, ip)
        Repositories::Redis::UniqVisitsCount.new(@config.redis).inc(endpoint)
        Repositories::Redis::UniqIpsForEndpoint.new(@config.redis).add(endpoint, ip)
      end

      Repositories::Redis::VisitsCount.new(@config.redis).inc(endpoint)

      Success(true)
    end
  end
end
