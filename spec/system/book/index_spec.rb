require 'rails_helper'

RSpec.describe 'index category', type: :system do
  let!(:user1) { FactoryBot.create(:test_user) }
  let!(:user2) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category, owner_id: user1.id) }
  let!(:book1) do
    FactoryBot.create(:book, title: 'Book about cars', status: 3, owner_id: user1.id, categories: [category.id])
  end
  let!(:book2) { FactoryBot.create(:book, title: 'Book about animals', author: 'Anonymus', owner_id: user1.id) }
  let!(:book3) { FactoryBot.create(:book, owner_id: user2.id) }

  before do
    login_as(user1)
  end

  scenario 'shows only books owned by specific user' do
    visit books_path
    expect(page).to have_content(book1.title)
    expect(page).to have_content(book2.title)
    expect(page).to_not have_content(book3.title)
  end

  scenario 'allow to search books by title' do
    visit books_path
    fill_in 'Title', with: 'car'
    click_button 'Search'
    sleep 1
    expect(page).to have_content(book1.title)
    expect(page).to_not have_content(book2.title)
  end

  scenario 'allow to search books by author' do
    visit books_path
    fill_in 'Author', with: 'anonymus'
    click_button 'Search'
    sleep 1
    expect(page).to have_content(book2.author)
    expect(page).to_not have_content(book1.author)
  end

  scenario 'allow to search books by staus' do
    visit books_path
    select 'to buy', from: 'Status'
    click_button 'Search'
    sleep 1
    expect(page).to have_content(book1.title)
    expect(page).to_not have_content(book2.title)
  end

  scenario 'allow to search books by categories' do
    visit books_path
    check category.name
    click_button 'Search'
    sleep 1
    expect(page).to have_content(book1.title)
    expect(page).to_not have_content(book2.title)
  end
end
