require 'rails_helper'

RSpec.describe FilePath do
  let(:file_path) { described_class.new(path_uri) }
  let(:path_uri) { "file://" + path }

  shared_examples "object methods succeed" do
    describe "#uri" do
      it "returns the encoded uri" do
        expect(file_path.uri).to eq encoded_uri
      end
    end

    describe "#clean" do
      it "returns the URI without the file schema" do
        expect(file_path.clean).to eq clean_path
      end
    end
  end

  context "with a plain path" do
    let(:path) { "/bla/test/Test.tiff" }
    let(:clean_path) { path }
    let(:encoded_uri) { path_uri }

    include_examples "object methods succeed"
  end

  context "with a path including spaces" do
    let(:path) { "/bla/test/Test with spaces.tiff" }
    let(:clean_path) { "/bla/test/Test%20with%20spaces.tiff" }
    let(:encoded_uri) { "file:///bla/test/Test%20with%20spaces.tiff" }

    include_examples "object methods succeed"
  end
end
