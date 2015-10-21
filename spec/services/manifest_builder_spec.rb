require 'rails_helper'

RSpec.describe ManifestBuilder, vcr: { cassette_name: "iiif_manifest" } do
  subject { described_class.new(solr_document) }

  let(:solr_document) { ScannedResourceShowPresenter.new(SolrDocument.new(record.to_solr), nil) }
  let(:record) { FactoryGirl.build(:scanned_resource) }
  before do
    allow(record).to receive(:persisted?).and_return(true)
    allow(record).to receive(:id).and_return("1")
  end

  describe "#canvases" do
    context "when there is a generic file" do
      let(:type) { ::RDF::URI('http://pcdm.org/use#ExtractedText') }
      let(:file_set) do
        FileSet.new.tap do |g|
          allow(g).to receive(:persisted?).and_return(true)
          allow(g).to receive(:id).and_return("x633f104m")
        end
      end
      let(:solr) { ActiveFedora.solr.conn }
      before do
        record.ordered_members << file_set
        record.file_set_ids # Initialize the stubbed IDs
        solr.add file_set.to_solr
        solr.commit
      end
      let(:first_canvas) { subject.canvases.first }
      it "has one" do
        expect(subject.canvases.length).to eq 1
      end
      it "has a label" do
        expect(first_canvas.label).to eq file_set.to_s
      end
      it "has a viewing hint" do
        file_set.viewing_hint = "paged"
        solr.add file_set.to_solr
        solr.commit

        expect(first_canvas.viewing_hint).to eq "paged"
      end
      it "is a valid manifest" do
        expect { subject.manifest.to_json }.not_to raise_error
      end
      it "has an image" do
        first_image = first_canvas.images.first
        expect(first_canvas.images.length).to eq 1
        expect(first_image.resource.format).to eq "image/jpeg"
        expect(first_image.resource.service['@id']).to eq "http://192.168.99.100:5004/x6%2F33%2Ff1%2F04%2Fm-intermediate_file.jp2"
        expect(first_image["on"]).to eq first_canvas['@id']
      end
    end
    it "has none" do
      expect(subject.canvases).to eq []
    end
  end

  describe "#manifest" do
    let(:result) { subject.manifest }
    xit "should have a good JSON-LD result" do
    end
    it "has a label" do
      expect(result.label).to eq record.to_s
    end
    it "has an ID" do
      expect(result['@id']).to eq "http://plum.com/concern/scanned_resources/1/manifest"
    end
    it "has a description" do
      expect(result.description).to eq record.description
    end
    it "has a viewing hint" do
      record.viewing_hint = "paged"
      expect(result.viewing_hint).to eq "paged"
    end
    it "has a default viewing hint" do
      expect(result.viewing_hint).to eq "individuals"
    end
    it "has a viewing direction" do
      record.viewing_direction = "right-to-left"
      expect(result.viewing_direction).to eq "right-to-left"
    end
    it "has a default viewing direction" do
      expect(result.viewing_direction).to eq "left-to-right"
    end
    it "is valid" do
      expect { subject.manifest.to_json }.not_to raise_error
    end
  end
end