# frozen_string_literal: true

require 'byebug'
require 'resolv'
require 'dry/monads'

module Services
  # All services should be act as monads, and have only one public method call
  # which return Success or Failure
  # Class which get file and start parsing it row by row and put to next service
  class ParseFile
    include Dry::Monads[:result]

    def initialize(config)
      @config = config
    end

    def call(file)
      result = choose_parser(file).bind do |parser|
        file.each do |row|
          data = parser.new.call(row)

          write_result_in_db(data)
        end
      end

      return result if result.respond_to?(:failure?) && result.failure?

      Success(true)
    ensure
      file.close
    end

    private

    def write_result_in_db(result)
      if result.failure?
        Repositories::Redis::Logger.new(@config.redis).error(result.failure)
      else
        endpoint, ip = result.success
        Services::CountVisits.new(@config).call(endpoint: endpoint, ip: ip)
      end
    end

    def choose_parser(file)
      case extension_for(file)
      when 'log'
        Success(Services::Parsers::FileLog)
      else
        Failure("Parser doesnt implemented for format: #{extension_for(file)}")
      end
    end

    def extension_for(file)
      file.path.split('.').last
    end
  end
end
