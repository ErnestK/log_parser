# frozen_string_literal: true

module Repositories
  # Repository( interface from java ) for Logger,
  # which only describes how repo should works
  # in that case all code doesnt know which db it uses and how
  # use raise NotImplementedError to ensure not call interface and call implementation
  module LoggerRepository
    def error(_str)
      raise NotImplementedError, 'Child must implement the following method!'
    end

    def error_exists?
      raise NotImplementedError, 'Child must implement the following method!'
    end

    def info(_str)
      raise NotImplementedError, 'Child must implement the following method!'
    end

    def all_errors
      raise NotImplementedError, 'Child must implement the following method!'
    end

    def all_info
      raise NotImplementedError, 'Child must implement the following method!'
    end
  end
end
