# frozen_string_literal: true

RSpec.describe Repositories::Redis::RedisApi, '#flush' do
  context 'with already filled DB' do
    let(:redis) { Redis.new }
    subject { Repositories::Redis::RedisApi.new(redis) }

    before(:each) do
      Redis.new.flushall
    end

    after(:all) do
      Redis.new.flushall
    end

    it 'flush all db' do
      redis.set 'test', 'A'
      expect(redis.strlen('test')).to eq 1
      subject.flush

      expect(redis.strlen('test')).to eq 0
    end
  end
end
