# frozen_string_literal: true

RSpec.describe Repositories::Redis::UniqIpsForEndpoint do
  let(:redis) { Redis.new }
  subject { Repositories::Redis::UniqIpsForEndpoint.new(redis) }

  let(:endpoint) { 'test_endpoint' }
  let(:ip) { 'test_ip' }

  before(:each) do
    Redis.new.flushall
  end

  after(:all) do
    Redis.new.flushall
  end

  describe '#not_exist?' do
    context 'when DB not include element' do
      it 'return true' do
        expect(subject.not_exist?(endpoint, ip)).to eq true
      end
    end

    context 'when DB include element' do
      it 'return false' do
        subject.add(endpoint, ip)

        expect(subject.not_exist?(endpoint, ip)).to eq false
      end
    end
  end

  describe '#add' do
    context 'when call method' do
      it 'added into collection' do
        expect(subject.not_exist?(endpoint, ip)).to eq true
        subject.add(endpoint, ip)

        expect(subject.not_exist?(endpoint, ip)).to eq false
      end
    end
  end
end
