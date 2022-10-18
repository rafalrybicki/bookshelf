require 'rails_helper'

RSpec.describe 'show category', type: :system do
  let(:user) { FactoryBot.create(:test_user) }
  let(:book) { FactoryBot.create(:book, owner_id: user.id) }

  scenario 'shows specific book' do
    login_as(user)
    visit book_path(book)

    expect(page).to have_content(book.author)
    expect(page).to have_content(book.title)
    expect(page).to have_content(book.status)
  end
end
