require 'rails_helper'

RSpec.describe CurationConcerns::MultiVolumeWorkForm do
  let(:form) { described_class.new(work, nil) }
  let(:work) { MultiVolumeWork.new }

  it "doesn't initialize description" do
    expect(form.description).to eq nil
  end
end
