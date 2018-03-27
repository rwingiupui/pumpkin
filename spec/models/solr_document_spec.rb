require 'rails_helper'

RSpec.describe SolrDocument do
  let(:solr_doc) { described_class.new(document_hash) }
  let(:date_created) { "2015-09-02" }
  let(:document_hash) do
    {
      date_created_tesim: date_created,
      language_tesim: ['eng'],
      width_is: 200,
      height_is: 400
    }
  end

  describe "#date_created" do
    it "returns date_created_tesim" do
      expect(solr_doc.date_created).to eq date_created
    end
  end

  describe "#height" do
    it "returns the height_is" do
      expect(solr_doc.height).to eq 400
    end
  end

  describe "#width" do
    it "returns the width_is" do
      expect(solr_doc.width).to eq 200
    end
  end

  describe "#logical_order" do
    it "is an empty hash by default" do
      expect(solr_doc.logical_order).to eq({})
    end
  end

  describe '#ocr_langage' do
    it 'defaults to language if not present' do
      expect(solr_doc['ocr_language_tesim']).to be nil
      expect(solr_doc.language).to eq(['eng'])
      expect(solr_doc.ocr_language).to eq(['eng'])
    end
  end
end
