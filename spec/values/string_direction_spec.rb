require 'rails_helper'

RSpec.describe String do
  describe "#dir" do
    context "when given an arabic string" do
      let(:string) { "حكاية" }

      it "returns rtl" do
        expect(string.dir).to eq "rtl"
      end
    end
    context "when given an english string" do
      let(:string) { "string" }

      it "returns ltr" do
        expect(string.dir).to eq "ltr"
      end
    end
  end
end
