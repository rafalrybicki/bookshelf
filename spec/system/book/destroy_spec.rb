require 'rails_helper'

RSpec.describe 'destroy book', type: :system do
  let(:user) { FactoryBot.create(:test_user) }
  let!(:book1) { FactoryBot.create(:book, owner_id: user.id) }
  let!(:book2) { FactoryBot.create(:book, owner_id: user.id) }

  scenario 'destroys specific book' do
    login_as(user)
    visit books_path

    expect(page).to have_content(book1.title)
    expect(page).to have_content(book2.title)
    expect(Book.count).to eq(2)

    click_link book1.title

    expect(page).to have_current_path(book_path(book1))

    click_link 'Delete'

    expect(Book.count).to eq(1)
    expect(page).to have_current_path(books_path)
    expect(page).to have_content('Book was successfully deleted')
    expect(page).to_not have_content(book1.title)
  end
end
