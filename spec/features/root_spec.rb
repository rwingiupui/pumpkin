require 'rails_helper'

RSpec.describe 'Home Page', type: :feature do
  describe 'a logged in user' do
    let(:user) { FactoryGirl.create(:image_editor) }

    before(:each) do
      sign_in user
    end

    it 'Logged in users see welcome text and links to create content' do
      visit root_path
      expect(page).to have_content('Pages Online')
      expect(page).to have_selector('li.work-type/h3.title',
                                    text: 'Scanned Resource')
      expect(page).to have_selector('li.work-type/h3.title',
                                    text: 'Collection')
    end
  end

  describe 'an anonymous user' do
    it 'Anonymous users see only welcome text' do
      visit root_path
      expect(page).to have_content('Pages Online')
      expect(page).not_to have_selector('li.work-type/h3.title',
                                        text: 'Scanned Resource')
      expect(page).not_to have_selector('li.work-type/h3.title',
                                        text: 'Collection')
    end
  end
end
