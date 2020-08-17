# frozen_string_literal: true

require 'dry/monads'

module Services
  # All services should be act as monads, and have only one public method call
  # which return Success or Failure
  # Class which start parse log file
  class ParseLog
    include Dry::Monads[:result]

    def initialize(config)
      @config = config
    end

    def call(file_path)
      open_file(file_path).bind do |file|
        Services::ParseFile.new(@config).call(file)
      end
    end

    private

    def open_file(file_path)
      if File.file?(file_path)
        # return as object doesnt load into memory
        Success(File.open(file_path, 'r'))
      else
        Failure('cant open file!')
      end
    end
  end
end
