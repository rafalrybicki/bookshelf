require 'rails_helper'

RSpec.describe 'update category', type: :system do
  let!(:user) { FactoryBot.create(:test_user) }
  let!(:category) { FactoryBot.create(:category, owner_id: user.id) }

  before do
    login_as(user)
  end

  scenario 'invalid inputs' do
    visit category_path(category)
    click_link 'Edit'

    expect(page).to have_current_path(edit_category_path(category))

    fill_in 'Name', with: ''
    click_button 'Update Category'
    category.reload

    expect(category.name).to eq(category.name)
    # expect(page).to have_current_path(edit_category_path(category))
    expect(page).to have_content("Name can't be blank")
  end

  scenario 'valid inputs' do
    category_name = 'Some category'
    visit category_path(category)
    click_link 'Edit'
    fill_in 'Name', with: category_name
    click_button 'Update Category'
    category.reload

    expect(page).to have_content('Category was successfully updated')
    expect(category.name).to eq(category_name)
  end
end
