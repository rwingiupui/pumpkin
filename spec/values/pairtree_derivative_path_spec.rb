require 'rails_helper'

describe PairtreeDerivativePath do
  before do
    allow(CurationConcerns.config).to receive(:derivatives_path) \
      .and_return('tmp')
  end

  describe '.derivative_path_for_reference' do
    let(:subject_path) {
      described_class.derivative_path_for_reference(object, destination_name)
    }
    let(:object) { instance_double(ResourceIdentifier, id: '08612n57q') }

    context "when given a thumbnail" do
      let(:destination_name) { 'thumbnail' }

      it 'is equal to thumbnail path' do
        expect(subject_path).to eq 'tmp/08/61/2n/57/q-thumbnail.jpeg'
      end
    end

    context "when given an intermediate file" do
      let(:destination_name) { 'intermediate_file' }

      it 'is equal to intermediate path' do
        expect(subject_path).to eq 'tmp/08/61/2n/57/q-intermediate_file.jp2'
      end
    end
    context "when given an unrecognized file" do
      let(:destination_name) { 'unrecognized' }

      it 'is equal to unrecognized path, suffix' do
        expect(subject_path).to eq 'tmp/08/61/2n/57/q-unrecognized.unrecognized'
      end
    end
    context "when given ocr" do
      let(:destination_name) { 'ocr' }

      it 'is equal to ocr.hocr path' do
        expect(subject_path).to eq 'tmp/08/61/2n/57/q-ocr.hocr'
      end
    end
    context "when given a PDF" do
      context "when it is color" do
        let(:destination_name) { 'color-pdf' }

        it "returns a unique PDF path based on the resource identifier" do
          identifier = instance_double(ResourceIdentifier)
          allow(ResourceIdentifier).to receive(:new).with(object.id) \
                                                    .and_return(identifier)
          allow(identifier).to receive(:to_s).and_return("banana")

          expect(subject_path).to eql "tmp/08/61/2n/57/q-banana-color-pdf.pdf"
        end
      end
      context "when it is gray" do
        let(:destination_name) { 'gray-pdf' }

        it "returns a unique PDF path based on the resource identifier" do
          identifier = instance_double(ResourceIdentifier)
          allow(ResourceIdentifier).to receive(:new).with(object.id) \
                                                    .and_return(identifier)
          allow(identifier).to receive(:to_s).and_return("banana")

          expect(subject_path).to eql "tmp/08/61/2n/57/q-banana-gray-pdf.pdf"
        end
      end
    end
  end
end
