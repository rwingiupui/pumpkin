require 'rails_helper'

RSpec.describe AllCollectionsPresenter do
  let(:presenter) { described_class.new }

  it "can be used to build a manifest" do
    expect { AllCollectionsManifestBuilder.new(presenter).to_json } \
      .not_to raise_error
  end

  it "has a title" do
    expect(presenter.title).to eq "Plum Collections"
  end

  it "has a description" do
    expect(presenter.description) \
      .to eq "All collections which are a part of Plum."
  end
end
