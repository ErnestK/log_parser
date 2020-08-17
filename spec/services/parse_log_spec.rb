# frozen_string_literal: true

RSpec.describe Services::ParseLog, '#call' do
  include Dry::Monads[:result]

  let(:config) { Config.new }
  subject { Services::ParseLog.new(config) }

  context 'when can open file' do
    it 'returns object file wrapped into Success' do
      expect(subject.call('spec/fixtures/files/input.log')).to eq Success(true)
    end
  end

  context 'when cant find file/filepath' do
    it 'returns message wpared into Failure' do
      expect(subject.call('spec/fixtures/files/not_found.log')).to eq Failure('cant open file!')
    end
  end
end
