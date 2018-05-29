require 'rails_helper'

RSpec.describe IngestCounter do
  let(:counter) { described_class.new(2) }
  let(:http) { instance_double(Net::HTTP::Persistent) }

  describe '#increment' do
    it 'counts' do
      expect(counter.increment).to eq(1)
    end

    it 'pauses http when limit is reached and resets count' do
      allow(Net::HTTP::Persistent).to receive(:new).and_return(http)
      expect(http).to receive(:shutdown)
      expect(counter.increment).to eq(1)
      expect(counter.increment).to eq(0)
    end
  end
end
