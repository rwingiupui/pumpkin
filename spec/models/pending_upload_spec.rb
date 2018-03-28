require 'rails_helper'

RSpec.describe PendingUpload, type: :model do
  let(:pending_upload) { FactoryGirl.build(:pending_upload) }

  describe "#validations" do
    it "has a valid factory" do
      expect(pending_upload).to be_valid
    end
    context "when curation_concern_id is blank" do
      it "is invalid" do
        pending_upload.curation_concern_id = nil

        expect(pending_upload).not_to be_valid
      end
    end
    context "when upload_set_id is blank" do
      it "is invalid" do
        pending_upload.upload_set_id = nil

        expect(pending_upload).not_to be_valid
      end
    end
    context "when file_name is blank" do
      it "is invalid" do
        pending_upload.file_name = nil

        expect(pending_upload).not_to be_valid
      end
    end
    context "when file_path is blank" do
      it "is invalid" do
        pending_upload.file_path = nil

        expect(pending_upload).not_to be_valid
      end
    end
  end
end
