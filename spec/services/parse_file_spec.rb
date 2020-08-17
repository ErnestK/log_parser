# frozen_string_literal: true

RSpec.describe Services::ParseFile, '#call' do
  include Dry::Monads[:result]

  let(:config) { Config.new }
  subject { Services::ParseFile.new(config) }
  let(:file) { File.open('spec/fixtures/files/bad.extension', 'r') }

  context 'when cant find parser' do
    it 'returns message wrapped into Failure' do
      expect(subject.call(file)).to eq Failure('Parser doesnt implemented for format: extension')
    end
  end
end
