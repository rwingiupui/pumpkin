require 'rails_helper'

RSpec.describe HoldingLocationService do
  let(:service) { described_class.find(uri) }

  let(:uri) { 'https://libraries.indiana.edu/music' }
  let(:email) { 'libmus@indiana.edu' }
  let(:label) { 'William & Gayle Cook Music Library' }
  let(:phone) { '(812) 855-2970' }

  context "with rights statements" do
    it "gets the email of a holding location" do
      expect(service.email).to eq(email)
    end

    it "gets the label of a holding location" do
      expect(service.label).to eq(label)
    end

    it "gets the phone number of a holding location" do
      expect(service.phone).to eq(phone)
    end
  end
end
