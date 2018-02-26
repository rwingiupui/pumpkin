require 'rails_helper'

RSpec.describe StateBadge do
  describe "pending" do
    let(:state_badge) { described_class.new('type', 'pending') }

    it "renders a badge" do
      expect(state_badge.render).to include("label-default")
      expect(state_badge.render).to include("Pending")
    end
  end

  describe "metadata_review" do
    let(:state_badge) { described_class.new('type', 'metadata_review') }

    it "renders a badge" do
      expect(state_badge.render).to include("label-info")
      expect(state_badge.render).to include("Metadata Review")
    end
  end

  describe "final_review" do
    let(:state_badge) { described_class.new('type', 'final_review') }

    it "renders a badge" do
      expect(state_badge.render).to include("label-primary")
      expect(state_badge.render).to include("Final Review")
    end
  end

  describe "complete" do
    let(:state_badge) { described_class.new('type', 'complete') }

    it "renders a badge" do
      expect(state_badge.render).to include("label-success")
      expect(state_badge.render).to include("Complete")
    end
  end

  describe "flagged" do
    let(:state_badge) { described_class.new('type', 'flagged') }

    it "renders a badge" do
      expect(state_badge.render).to include("label-warning")
      expect(state_badge.render).to include("Flagged")
    end
  end

  describe "takedown" do
    let(:state_badge) { described_class.new('type', 'takedown') }

    it "renders a badge" do
      expect(state_badge.render).to include("label-danger")
      expect(state_badge.render).to include("Takedown")
    end
  end
end
