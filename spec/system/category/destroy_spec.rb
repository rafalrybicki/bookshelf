require 'rails_helper'

RSpec.describe 'destroy category', type: :system do
  let!(:user) { FactoryBot.create(:test_user) }
  let!(:category1) { FactoryBot.create(:category, owner_id: user.id) }
  let!(:category2) { FactoryBot.create(:category, owner_id: user.id) }

  scenario 'destroys specific category' do
    login_as(user)
    visit categories_path

    expect(page).to have_content(category1.name)
    expect(page).to have_content(category2.name)
    expect(Category.count).to eq(2)

    click_link category1.name

    expect(page).to have_current_path(category_path(category1))

    click_link 'Delete'

    expect(Category.count).to eq(1)
    expect(page).to have_current_path(categories_path)
    expect(page).to have_content('Category was successfully deleted')
    expect(page).to_not have_content(category1.name)
  end
end
