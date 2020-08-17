# frozen_string_literal: true

require 'require_all'
require 'dry/monads'
require 'dotenv/load'

require_all 'app'

# Main app, which we call, and it process all work
# call Service(all services its monads)
# and print result to printer
class Main
  include Dry::Monads[:result]

  def call(file_path)
    config = Config.new

    result = Services::ParseLog.new(config).call(file_path)

    if result.failure?
      config.printer.print result.failure
      return
    end

    config.printer.print_reports(config)
  ensure
    Repositories::Redis::RedisApi.new(config.redis).flush
  end
end
