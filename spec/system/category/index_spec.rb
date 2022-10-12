require 'rails_helper'

RSpec.describe 'index category', type: :system do
  let!(:user1) { FactoryBot.create(:test_user) }
  let!(:user2) { FactoryBot.create(:user) }
  let!(:category1) { FactoryBot.create(:category, owner_id: user1.id) }
  let!(:category2) { FactoryBot.create(:category, owner_id: user2.id) }

  scenario 'shows only categories owned by specific user' do
    login_as(user1)
    visit categories_path

    expect(page).to have_content(category1.name)
    expect(page).to_not have_content(category2.name)
    expect(Category.count).to eq(2)
    expect(user1.categories.count).to eq(1)
  end
end
