require 'rails_helper'

RSpec.describe 'update book', type: :system do
  let!(:user) { FactoryBot.create(:test_user) }
  let!(:book) { FactoryBot.create(:book, owner_id: user.id) }

  before do
    login_as(user)
  end

  scenario 'with invalid inputs' do
    visit book_path(book)
    click_link 'Edit'

    expect(page).to have_current_path(edit_book_path(book))

    fill_in 'Title', with: ''
    fill_in 'Author', with: ''
    click_button 'Update Book'
    book.reload

    expect(book.title).to eq(book.title)
    expect(book.author).to eq(book.author)
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Author can't be blank")
  end

  scenario 'with valid inputs' do
    new_title = 'New title'
    new_author = 'New Author'
    visit book_path(book)
    click_link 'Edit'
    fill_in 'Title', with: new_title
    fill_in 'Author', with: new_author
    click_button 'Update Book'
    book.reload

    expect(book.title).to eq(new_title)
    expect(book.author).to eq(new_author)
    expect(page).to have_content('Book was successfully updated')
    expect(page).to have_content(new_title)
    expect(page).to have_content(new_author)
  end
end
