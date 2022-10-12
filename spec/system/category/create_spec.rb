require 'rails_helper'

RSpec.describe 'create category', type: :system do
  let(:category_name) { 'Some category' }

  before do
    login_as(FactoryBot.create(:test_user))
  end

  scenario 'invalid inputs' do
    visit categories_path
    click_link 'Add new Category'

    expect(page).to have_current_path(new_category_path)

    fill_in 'Name', with: ''
    click_button 'Create Category'

    expect(Category.count).to eq(0)
    # expect(page).to have_current_path(new_category_path)
    expect(page).to have_content("Name can't be blank")
  end

  scenario 'valid inputs' do
    visit categories_path
    click_link 'Add new Category'

    expect(page).to have_current_path(new_category_path)

    fill_in 'Name', with: category_name
    click_button 'Create Category'

    expect(Category.count).to eq(1)
    expect(Category.last.name).to eq(category_name)
    expect(page).to have_current_path(category_path(Category.last))
    expect(page).to have_content('Category was successfully created')
    expect(page).to have_content(category_name)
  end
end
