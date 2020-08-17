# frozen_string_literal: true

RSpec.describe Repositories::Redis::Logger do
  let(:redis) { Redis.new }
  subject { Repositories::Redis::Logger.new(redis) }

  before(:each) do
    Redis.new.flushall
  end

  after(:all) do
    Redis.new.flushall
  end

  describe '#error' do
    context 'when call with error message' do
      it 'put in collection' do
        expect(subject.all_errors.size).to eq 0

        subject.error('Some error!')

        expect(subject.all_errors.size).to eq 1
      end
    end
  end

  describe '#error_exists?' do
    context 'when add error' do
      it 'return change from false to true' do
        expect(subject.error_exists?).to eq false

        subject.error('Some error!')

        expect(subject.error_exists?).to eq true
      end
    end
  end

  describe '#info' do
    context 'when call with info message' do
      it 'put in collection' do
        expect(subject.all_info.size).to eq 0

        subject.info('Some info!')

        expect(subject.all_info.size).to eq 1
      end
    end
  end

  describe '#all_errors' do
    context 'when call method' do
      it 'returns all errors logs in array models Log' do
        info_message = 'Some error!'
        subject.error(info_message)

        expect(subject.all_errors.size).to eq 1
        expect(subject.all_errors.first.class).to eq Models::Log
        expect(subject.all_errors.first.data).to eq info_message
      end
    end
  end

  describe '#all_info' do
    context 'when call method' do
      it 'return all info logs in array models Log' do
        info_message = 'Some info'
        subject.info(info_message)

        expect(subject.all_info.size).to eq 1
        expect(subject.all_info.first.class).to eq Models::Log
        expect(subject.all_info.first.data).to eq info_message
      end
    end
  end
end
