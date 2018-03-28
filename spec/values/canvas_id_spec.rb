require 'rails_helper'

RSpec.describe CanvasID do
  let(:canvas_id) { described_class.new(id, parent_path) }

  let(:parent_path) { "http://test.com/manifest" }
  let(:id) { "1" }

  describe "#to_s" do
    it "returns a good path" do
      expect(canvas_id.to_s).to eq "http://test.com/manifest/canvas/1"
    end
  end
end
