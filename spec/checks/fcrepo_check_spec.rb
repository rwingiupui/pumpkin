require 'rails_helper'

RSpec.describe IuDevOps::FcrepoCheck do
  let(:fcrepo_check) {
    described_class.new(ActiveFedora.fedora_config.credentials[:url], 5,
                        [ActiveFedora.fedora_config.credentials[:user],
                         ActiveFedora.fedora_config.credentials[:password]])
  }

  describe '#check' do
    context 'when Fedora is up' do
      it 'reports success' do
        fcrepo_check.check
        expect(fcrepo_check.success?).to eq(true)
      end
    end

    context 'when Fedora is down' do
      before { fcrepo_check.url = "#{fcrepo_check.url}/badpath" }
      it 'reports failure' do
        fcrepo_check.check
        expect(fcrepo_check.success?).to eq(false)
      end
    end
  end
end
