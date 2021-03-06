# frozen_string_literal: true

require_relative '../visits_count_repository.rb'

module Repositories
  module Redis
    # Redis repo impl which implement all repo methods
    # we could create one impl for all repo, but in this way its better to read, maintain..
    class VisitsCount < RedisApi
      include ::Repositories::VisitsCountRepository

      def inc(endpoint)
        @db.zincrby(collection_name, 1, endpoint)
      end

      def all_ordered
        @db.zrevrange(collection_name, 0, -1, with_scores: true).map do |raw_data|
          api_with_score = Models::ApiWithScore.new
          api_with_score.endpoint = raw_data.first
          api_with_score.score = raw_data.last

          api_with_score
        end
      end

      private

      def collection_name
        'sortedset:all_visits_count'
      end
    end
  end
end
