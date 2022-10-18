require 'rails_helper'

RSpec.describe 'create category', type: :system do
  let(:book_title) { 'Some book' }
  let(:book_author) { 'John Doe' }
  let(:book_status) { Book.statuses.keys[1] }
  let(:book_info) { Faker::Lorem.sentence }

  before do
    login_as(FactoryBot.create(:test_user))
  end

  scenario 'with invalid inputs' do
    visit books_path
    click_link 'Add new Book'

    expect(page).to have_current_path(new_book_path)

    fill_in 'Title', with: ''
    fill_in 'Author', with: ''
    click_button 'Create Book'

    expect(Book.count).to eq(0)
    # expect(page).to have_current_path(new_book_path)
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Author can't be blank")
  end

  scenario 'with valid inputs' do
    visit books_path
    click_link 'Add new Book'

    expect(page).to have_current_path(new_book_path)

    fill_in 'Title', with: book_title
    fill_in 'Author', with: book_author
    select book_status, from: 'Status'
    fill_in 'Info', with: book_info

    click_button 'Create Book'

    expect(Book.count).to eq(1)
    expect(Book.last.title).to eq(book_title)
    expect(Book.last.author).to eq(book_author)
    expect(Book.last.info).to eq(book_info)
    expect(Book.last.status).to eq(book_status)

    expect(page).to have_current_path(book_path(Book.last))
    expect(page).to have_content('Book was successfully created')
    expect(page).to have_content(book_title)
    expect(page).to have_content(book_author)
    expect(page).to have_content(book_info)
    expect(page).to have_content(book_status)
  end
end
