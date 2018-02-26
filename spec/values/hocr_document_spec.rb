require 'rails_helper'

RSpec.describe HOCRDocument do
  let(:hocr_doc) { described_class.new(document) }
  let(:document) {
    File.open(Rails.root.join("spec", "fixtures", "files", "test.hocr"))
  }

  describe "#text" do
    it "returns the combined text" do
      expect(hocr_doc.text).to eq "\n \n  \n\n\n  \n  \n\n\n  \n   \n    \n" \
      "     Studio per l’elaborazione informatica delle fonti" \
      " storico—artistiche \n     \n    \n   \n  \n\n"
    end
  end

  describe "#bounding_box" do
    it "doesn't return anything" do
      expect(hocr_doc.bounding_box.top_left.x).to eq nil
      expect(hocr_doc.bounding_box.top_left.y).to eq nil
      expect(hocr_doc.bounding_box.bottom_right.x).to eq nil
      expect(hocr_doc.bounding_box.bottom_right.y).to eq nil
    end
  end

  describe "#pages" do
    it "returns pages" do
      expect(hocr_doc.pages.length).to eq 1
      expect(hocr_doc.pages.first.bounding_box.top_left.x).to eq 0
      expect(hocr_doc.pages.first.bounding_box.top_left.y).to eq 0
      expect(hocr_doc.pages.first.bounding_box.bottom_right.x).to eq 4958
      expect(hocr_doc.pages.first.bounding_box.bottom_right.y).to eq 7017
    end
  end

  describe "#areas" do
    context "when they're deep" do
      it "returns them" do
        expect(hocr_doc.areas.length).to eq 1
      end
    end
    context "when there is one" do
      let(:hocr_doc) { described_class.new(document).pages.first }

      it "returns it" do
        expect(hocr_doc.areas.length).to eq 1

        first_area = hocr_doc.areas.first
        expect(first_area.bounding_box.top_left.x).to eq 471
        expect(first_area.bounding_box.top_left.y).to eq 727
        expect(first_area.bounding_box.bottom_right.x).to eq 4490
        expect(first_area.bounding_box.bottom_right.y).to eq 6710
      end
    end
  end

  describe "#paragraphs" do
    context "when they're deep" do
      it "returns them" do
        expect(hocr_doc.paragraphs.length).to eq 1
      end
    end
    context "when there is one" do
      let(:first_area) { described_class.new(document).pages.first.areas.first }

      it "returns it" do
        expect(first_area.paragraphs.length).to eq 1

        first_paragraph = first_area.paragraphs.first
        expect(first_paragraph.bounding_box.top_left.x).to eq 1390
        expect(first_paragraph.bounding_box.top_left.y).to eq 727
        expect(first_paragraph.bounding_box.bottom_right.x).to eq 3571
        expect(first_paragraph.bounding_box.bottom_right.y).to eq 1035
      end
    end
  end

  describe "#lines" do
    context "when they're deep" do
      it "returns them" do
        expect(hocr_doc.lines.length).to eq 1
      end
    end
    context "when there is one" do
      let(:first_paragraph) {
        described_class.new(document).pages.first.areas.first.paragraphs.first
      }

      it "returns it" do
        expect(first_paragraph.lines.length).to eq 1

        first_line = first_paragraph.lines.first
        expect(first_line.bounding_box.top_left.x).to eq 1390
        expect(first_line.bounding_box.top_left.y).to eq 960
        expect(first_line.bounding_box.bottom_right.x).to eq 3571
        expect(first_line.bounding_box.bottom_right.y).to eq 1035
      end
    end
  end
end
