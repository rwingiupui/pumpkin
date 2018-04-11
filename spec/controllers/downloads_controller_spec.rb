require 'rails_helper'

RSpec.describe DownloadsController do
  let(:user) { FactoryGirl.create(:admin) }
  let(:fileset) { FactoryGirl.build(:file_set) }
  let(:doc_path) { Rails.root.join("spec", "fixtures", "files", "test.hocr") }
  let(:iodec) { Hydra::Derivatives::IoDecorator.new(doc_path, 'text/xml', File.basename(doc_path)) }

  before do
    sign_in user
    Hydra::Works::AddFileToFileSet.call(fileset, iodec, :extracted_text)
  end

  describe "show" do
    context "when requested extracted text" do
      it "renders the extracted text file" do
        get :show, id: fileset, file: 'extracted_text'
        expect(response.body).to eq File.read(doc_path, mode: 'rb')
        expect(response.headers['Content-Length']).to eq "1714"
        expect(response.headers['Accept-Ranges']).to eq "bytes"
      end
    end
  end
end
