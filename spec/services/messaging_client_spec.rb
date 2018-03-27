require 'rails_helper'

RSpec.describe MessagingClient do
  let(:client) { described_class.new(url) }

  let(:url) { "amqp://test.x.z.s:4000" }

  describe "#publish" do
    context "when the URL is bad" do
      it "doesn't error" do
        expect { client.publish("testing") }.not_to raise_error
      end
    end
  end
  describe "#enabled?" do
    context "when the URL is not blank" do
      it "returns true" do
        expect(client.enabled?).to eq(true)
      end
    end
    context "when the URL is blank" do
      let(:client) { described_class.new(nil) }

      it "returns false" do
        expect(client.enabled?).to eq(false)
      end
    end
  end
end
