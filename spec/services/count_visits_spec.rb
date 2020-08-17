# frozen_string_literal: true

RSpec.describe Services::CountVisits, '#call' do
  include Dry::Monads[:result]
  let(:config) { Config.new }
  subject { Services::CountVisits.new(config) }
  let(:endpoint) { 'test_endpoint' }
  let(:ip) { 'test_ip' }

  let(:redis) { Redis.new }
  let(:endpont_with_api_collection) { Repositories::Redis::UniqIpsForEndpoint.new(redis) }
  let(:visits_for_endpoint_collection) { Repositories::Redis::VisitsCount.new(redis) }
  let(:uniq_visits_for_endpoint_collection) { Repositories::Redis::UniqVisitsCount.new(redis) }

  before(:each) do
    Redis.new.flushall
  end

  after(:all) do
    Redis.new.flushall
  end

  context 'when get endpoint and ip' do
    it 'Add into endpont_with_api_collection' do
      subject.call(endpoint: endpoint, ip: ip)

      expect(endpont_with_api_collection.not_exist?(endpoint, ip)).to eq false
    end

    it 'increment all visits' do
      expect(visits_for_endpoint_collection.all_ordered.size).to eq 0

      subject.call(endpoint: endpoint, ip: ip)

      expect(visits_for_endpoint_collection.all_ordered.size).to eq 1
    end

    it 'increment uniq visits' do
      expect(uniq_visits_for_endpoint_collection.all_ordered.size).to eq 0

      subject.call(endpoint: endpoint, ip: ip)

      expect(uniq_visits_for_endpoint_collection.all_ordered.size).to eq 1
    end
  end

  context 'when get ip which is not uniq' do
    it 'keeps uniq_visits_for_endpoint_collection size same' do
      endpont_with_api_collection.add(endpoint, ip)
      uniq_visits_for_endpoint_collection.inc(endpoint)

      expect(uniq_visits_for_endpoint_collection.all_ordered.size).to eq 1

      subject.call(endpoint: endpoint, ip: ip)

      expect(uniq_visits_for_endpoint_collection.all_ordered.size).to eq 1
    end
  end
end
