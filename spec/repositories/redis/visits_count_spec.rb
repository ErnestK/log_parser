# frozen_string_literal: true

RSpec.describe Repositories::Redis::VisitsCount do
  let(:redis) { Redis.new }
  subject { Repositories::Redis::VisitsCount.new(redis) }

  let(:endpoint) { 'test_endpoint' }
  let(:ip) { 'test_ip' }

  let(:second_endpoint) { 'second_test_endpoint' }

  before(:each) do
    Redis.new.flushall
  end

  after(:all) do
    Redis.new.flushall
  end

  describe '#inc' do
    context 'when call method' do
      it 'increments by 1' do
        subject.inc(endpoint)

        expect(subject.all_ordered.first.score).to eq 1
      end
    end
  end

  describe '#all_ordered' do
    context 'when call method' do
      it 'returns collection with order' do
        # Second on first place because we call increment for it 2 times
        expected_result = [second_endpoint, endpoint]

        subject.inc(endpoint)
        subject.inc(second_endpoint)
        subject.inc(second_endpoint)

        expect(subject.all_ordered.size).to eq 2
        expect(subject.all_ordered.first.class).to eq Models::ApiWithScore
        expect(subject.all_ordered.map(&:endpoint)).to eq expected_result
      end
    end
  end
end
