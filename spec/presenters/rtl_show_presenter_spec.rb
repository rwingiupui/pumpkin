require 'rails_helper'

RSpec.describe RTLShowPresenter do
  let(:presenter) { described_class.new(document, controller) }

  let(:document) do
    {
      field: ["بي", "one"]
    }
  end
  let(:blacklight_config) do
    instance_double("blacklight_config",
                    show_fields: {
                      field: Blacklight::Configuration::Field.new(field: :field)
                    },
                    index_fields: {
                      field: Blacklight::Configuration::Field.new(field: :field)
                    },
                    view_config: instance_double("struct", title_field: :field))
  end
  let(:controller) { instance_double("controller", blacklight_config: blacklight_config) }

  describe "#field_value" do
    context "when given a RTL string" do
      it "renders it as a RTL list item" do
        expect(presenter.field_value(:field)) \
          .to eq "<ul><li dir=\"rtl\">بي</li><li dir=\"ltr\">one</li></ul>"
      end
    end
  end
end
