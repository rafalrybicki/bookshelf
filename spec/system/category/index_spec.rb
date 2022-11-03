require 'rails_helper'

RSpec.describe 'index category', type: :system do
  let!(:user1) { FactoryBot.create(:test_user) }
  let!(:user2) { FactoryBot.create(:user) }
  let!(:category1) { FactoryBot.create(:category, owner_id: user1.id) }
  let!(:category2) { FactoryBot.create(:category, owner_id: user2.id) }

  before do
    login_as(user1)
    visit categories_path
  end

  scenario 'shows only categories owned by specific user' do
    expect(page).to have_content(category1.name)
    expect(page).to_not have_content(category2.name)
    expect(Category.count).to eq(2)
    expect(user1.categories.count).to eq(1)
  end

  scenario 'allow go to the books' do
    click_link 'Books'
    expect(page).to have_current_path(books_path)
  end

  scenario 'allow go to the categories' do
    click_link 'Categories'
    expect(page).to have_current_path(categories_path)
  end

  scenario 'allow logouts' do
    click_link 'Logout'
    expect(page).to have_current_path(new_user_session_path)
  end
end
