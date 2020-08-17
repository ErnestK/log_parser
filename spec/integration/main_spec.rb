# frozen_string_literal: true

require 'open3'

RSpec.describe Main, '#call' do
  subject { Main.new }

  before(:each) do
    Redis.new.flushall
  end

  after(:all) do
    Redis.new.flushall
  end

  context 'when all ok' do
    it 'print reports' do
      stdout, = Open3.capture3('./bin/main', 'spec/fixtures/files/input.log')

      expect(stdout).to eq File.read('spec/fixtures/outputs/output.log')
    end
  end

  context 'when errors has occurred' do
    it 'print errors and reports' do
      stdout, = Open3.capture3('./bin/main', 'spec/fixtures/files/input_with_errors.log')

      expect(stdout).to eq File.read('spec/fixtures/outputs/output_with_errors.log')
    end
  end

  # We test all different failure in specilaized test specs
  context 'when failure has occurred' do
    it 'print message' do
      stdout, = Open3.capture3('./bin/main', 'non_existing.file')

      expect(stdout).to eq "\"cant open file!\"\n"
    end
  end
end
