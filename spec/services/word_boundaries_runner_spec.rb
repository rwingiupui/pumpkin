require 'rails_helper'
RSpec.describe WordBoundariesRunner do
  let(:file_set) { FileSet.new }
  let(:runner) { described_class.new(file_set.id) }
  let(:doc) {
    File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.hocr')) \
    { |f| Nokogiri::HTML(f) }
  }
  let(:json) {
    File.read(Rails.root.join('spec', 'fixtures', 'files', 'test_json.json'))
  }

  before do
    allow(file_set).to receive(:id).and_return('123')
    allow(FileSet).to receive(:find).with('123').and_return(file_set)
    allow(File).to receive(:open).and_return(doc)
  end

  describe "#create" do
    context "when HOCR file is available" do
      # FIXME: either add unavailable context OR don't
      it "writes an equivalent jason representation" do
        # rubocop:disable RSpec/MessageSpies
        expect(File).to receive(:write).with(runner.json_filepath, json)
        # rubocop:enable RSpec/MessageSpies
        runner.create
      end
    end
    context "when no HOCR file is available" do
      pending "what does it do?!"
    end
  end

  describe "#hocr_filepath" do
    it "delegates to PairtreeDerivativePath" do
      # rubocop:disable RSpec/MessageSpies
      expect(PairtreeDerivativePath) \
        .to receive(:derivative_path_for_reference).with(file_set, "ocr")
      # rubocop:enable RSpec/MessageSpies
      runner.hocr_filepath
    end
  end
  describe "#json_filepath" do
    it "delegates to PairtreeDerivativePath" do
      # rubocop:disable RSpec/MessageSpies
      expect(PairtreeDerivativePath) \
        .to receive(:derivative_path_for_reference).with(file_set, "json")
      # rubocop:enable RSpec/MessageSpies
      runner.json_filepath
    end
  end
  describe "#hocr_exists" do
    context "when it exists" do
      pending "what does it do?!"
    end
    context "when it doesn't exist" do
      pending "what does it do?!"
    end
  end
  describe "#json_exists" do
    context "when it exists" do
      pending "what does it do?!"
    end
    context "when it doesn't exist" do
      pending "what does it do?!"
    end
  end
end
