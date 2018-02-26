RSpec.shared_examples "structural metadata" do
  # rubocop:disable RSpec/DescribeClass
  describe "#logical_order" do
    # rubocop:enable RSpec/DescribeClass
    let(:params) do
      {
        "label": "Top!",
        "nodes": [
          {
            "label": "Chapter 1",
            "nodes": [
              {
                "label": resource1.rdf_label.first,
                "proxy": resource1.id
              }
            ]
          },
          {
            "label": "Chapter 2",
            "nodes": [
              {
                "label": resource2.rdf_label.first,
                "proxy": resource2.id
              }
            ]
          }
        ]
      }
    end
    let(:params2) do
      {
        "nodes": [
          {
            "label": "Chapter 1",
            "nodes": [
              {
                "label": resource1.rdf_label.first,
                "proxy": resource1.id
              }
            ]
          },
          {
            "label": "Chapter 2",
            "nodes": [
              {
                "label": "Chapter 2b",
                "nodes": [
                  {
                    "label": resource2.rdf_label.first,
                    "proxy": resource2.id
                  }
                ]
              }
            ]
          }
        ]
      }
    end
    let(:resource1) { FactoryGirl.create(:file_set) }
    let(:resource2) { FactoryGirl.create(:file_set) }

    it "is a resource that can have an order" do
      expect(curation_concern.logical_order).to be_kind_of LogicalOrderBase
    end
    it "can have an order assigned" do
      curation_concern.logical_order.order = params

      expect(curation_concern.logical_order.resource.statements.to_a.length).to eq 20
    end
    it "marshals logical order into solr" do
      curation_concern.logical_order.order = params
      curation_concern.save
      expect(curation_concern.to_solr["logical_order_tesim"]) \
        .to eq [curation_concern.logical_order.order.to_json]
    end
    it "indexes the headings into the solr record" do
      curation_concern.logical_order.order = params2
      curation_concern.save

      expect(curation_concern.to_solr["logical_order_headings_tesim"]).to eq [
        "Chapter 1",
        "Chapter 2",
        "Chapter 2b"
      ]
    end
    it "can index even without order" do
      expect(curation_concern.to_solr["logical_order_headings_tesim"]).to eq []
    end
    it "survives persistence" do
      curation_concern.logical_order.order = params
      curation_concern.save

      expect(curation_concern.reload.logical_order.order) \
        .to eq params.with_indifferent_access
    end
    it "can have order pulled out of solr" do
      curation_concern.logical_order.order = params
      curation_concern.save

      doc =
        SolrDocument.new(ActiveFedora::SolrService.query("id:#{curation_concern.id}") \
                           .first)
      expect(doc.logical_order).to eq curation_concern.logical_order.order
    end
    it "has no order by default" do
      expect(curation_concern.logical_order.order).to eq({})
    end
    it "can have order re-assigned" do
      curation_concern.logical_order.order = params
      curation_concern.save
      curation_concern.reload
      curation_concern.logical_order.order = params2
      curation_concern.save

      expect(curation_concern.reload.logical_order.order) \
        .to eq params2.with_indifferent_access
    end
  end
end
