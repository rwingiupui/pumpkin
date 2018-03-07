RSpec.shared_examples "common metadata" do
  describe "#identifier" do
    # tests workaround for modifying property arity via schema inclusion
    it "returns false on multiple? check" do
      expect(curation_concern.class.multiple?(:identifier)).not_to be true
    end
  end
end
