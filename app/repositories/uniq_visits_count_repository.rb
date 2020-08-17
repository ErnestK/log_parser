# frozen_string_literal: true

module Repositories
  # Repository( interface from java ) for counting and increment uniq visits,
  # which only describes how repo should works
  # in that case all code doesnt know which db it uses and how
  # use raise NotImplementedError to ensure not call interface and call implementation
  module UniqVisitsCountRepository
    def inc(_endpoint)
      raise NotImplementedError, 'Child must implement the following method!'
    end

    def all_ordered
      raise NotImplementedError, 'Child must implement the following method!'
    end
  end
end
