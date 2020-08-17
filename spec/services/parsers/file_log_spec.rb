# frozen_string_literal: true

RSpec.describe Services::Parsers::FileLog, '#call' do
  include Dry::Monads[:result]

  subject { Services::Parsers::FileLog.new }

  context 'when all ok' do
    let(:valid_row) { '/help_page/1 192.128.0.12' }

    it 'return endpoint and api wrapped into Success' do
      expected_output = Success(['/help_page/1', '192.128.0.12'])

      expect(subject.call(valid_row)).to eq expected_output
    end
  end

  context 'when row size invalid' do
    let(:row_with_invalid_ip) { '/help_page/1 192.128.0.12 and so on' }

    it 'return Failure' do
      expected_output =
        Failure('Should have 2 elements delimiter by space, invalid row: /help_page/1 192.128.0.12 and so on')

      expect(subject.call(row_with_invalid_ip)).to eq expected_output
    end
  end

  context 'when ip not valid' do
    let(:row_with_invalid_ip) { '/help_page/1 192.128.0.111112' }

    it 'return Failure' do
      ENV['VALIDATE_IP'] = 'true'
      expected_output = Failure('Invalid ip: 192.128.0.111112')

      expect(subject.call(row_with_invalid_ip)).to eq expected_output
    end
  end

  context 'when endpoint not valid' do
    let(:row_with_invalid_ip) { '^&9988&*^* 192.128.0.12' }

    it 'return Failure' do
      expected_output = Failure('Invalid endoint data: ^&9988&*^*')

      expect(subject.call(row_with_invalid_ip)).to eq expected_output
    end
  end
end
