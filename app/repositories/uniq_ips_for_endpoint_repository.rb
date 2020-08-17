# frozen_string_literal: true

module Repositories
  # Repository( interface from java ) for collection
  # which keeps all endpoint and association to uniq ip which already visit that endpoint,
  # repo only describes how repo should works
  # in that case all code doesnt know which db it uses and how
  # use raise NotImplementedError to ensure not call interface and call implementation
  module UniqIpsForEndpointRepository
    def not_exist?(_endpoint, _ip)
      raise NotImplementedError, 'Child must implement the following method!'
    end

    def add(_endpoint, _ip)
      raise NotImplementedError, 'Child must implement the following method!'
    end
  end
end
