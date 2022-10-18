require 'rails_helper'

RSpec.describe 'index category', type: :system do
  let!(:user1) { FactoryBot.create(:test_user) }
  let!(:user2) { FactoryBot.create(:user) }
  let!(:book1) { FactoryBot.create(:book, owner_id: user1.id) }
  let!(:book2) { FactoryBot.create(:book, owner_id: user2.id) }

  scenario 'shows only books owned by specific user' do
    login_as(user1)
    visit books_path

    expect(page).to have_content(book1.title)
    expect(page).to_not have_content(book2.title)
  end
end
