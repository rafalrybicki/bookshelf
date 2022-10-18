require 'rails_helper'

RSpec.describe 'Books', type: :request do
  let(:user) { FactoryBot.create :user }
  let(:other_user) { FactoryBot.create :user }
  let!(:user_book) { FactoryBot.create :book, owner_id: user.id }
  let!(:other_user_book) { FactoryBot.create :book, owner_id: other_user.id }
  let!(:user_category) { FactoryBot.create :category, owner_id: user.id }
  let(:valid_parameters) { { book: { title: 'Some title', author: 'Some Author' } } }
  let(:invalid_parameters) { { book: { title: nil, author: nil } } }

  before do
    sign_in user
  end

  describe 'GET /books' do
    include_examples 'requires login', :get, -> { books_path }

    context 'when logged in' do
      before(:example) { get books_path }
      it { expect(response).to have_http_status(:success) }

      it { expect(response).to render_template(:index) }

      it { expect(response.body).to include(user_book.title) }

      it { expect(response.body).to_not include(other_user_book.title) }
    end
  end

  describe 'GET /books/:id' do
    include_examples 'requires login', :get, -> { book_path(user_book) }

    context 'when logged in' do
      include_examples 'requires owner', :get, -> { book_path(other_user_book) }

      before(:example) { get book_path(user_book) }

      it { expect(response).to have_http_status(:success) }

      it { expect(response).to render_template(:show) }

      it { expect(response.body).to include(user_book.title) }
    end
  end

  describe 'GET /books/new' do
    include_examples 'requires login', :get, -> { new_book_path }

    context 'when logged in' do
      before(:example) { get new_book_path }

      it { expect(response).to have_http_status(:success) }

      it { expect(response).to render_template(:new) }
    end
  end

  describe 'POST /books' do
    include_examples 'requires login', :post, -> { books_path(valid_parameters) }

    context 'when logged in' do
      context 'with valid parameters' do
        before(:example) { post books_path(valid_parameters) }

        it {
          expect do
            post books_path(valid_parameters)
          end.to change(Book, :count).by(1)
        }

        it { expect(response).to have_http_status(:redirect) }

        it { expect(response).to redirect_to(book_path(Book.last)) }

        it {
          follow_redirect!
          expect(response).to render_template(:show)
        }

        it {
          follow_redirect!
          expect(response.body).to include(Book.last.author)
        }

        it {
          follow_redirect!
          expect(response.body).to include(Book.last.title)
        }
      end

      context 'with invalid parameters' do
        before(:each) { post books_path(invalid_parameters) }

        it {
          expect do
            post books_path(invalid_parameters)
          end.to change(Book, :count).by(0)
        }

        it { expect(response).to have_http_status(:unprocessable_entity) }

        it { expect(response).to render_template(:new) }
      end
    end
  end

  describe 'GET /books/:id/edit' do
    include_examples 'requires login', :get, -> { edit_book_path(user_book) }

    context 'when logged in' do
      include_examples 'requires owner', :get, -> { edit_book_path(other_user_book) }

      before(:example) { get edit_book_path(user_book) }

      it { expect(response).to have_http_status(:success) }

      it { expect(response).to render_template(:edit) }
    end
  end

  describe 'PATCH /books/:id' do
    include_examples 'requires login', :patch, -> { book_path(user_book, valid_parameters) }

    context 'when logged in' do
      include_examples 'requires owner', :patch, -> { book_path(other_user_book, valid_parameters) }

      context 'with valid parameters' do
        let(:new_book_title) { valid_parameters[:book][:title] }

        before(:example) { patch book_path(user_book, valid_parameters) }

        it {
          user_book.reload
          expect(user_book.title).to eq new_book_title
        }

        it {
          expect(response).to redirect_to(book_path(user_book))
        }

        it {
          follow_redirect!
          expect(response).to render_template(:show)
        }
      end

      context 'with invalid parameters' do
        let(:old_title) { user_book.title }

        before(:example) { patch book_path(user_book, invalid_parameters) }

        it {
          user_book.reload
          expect(user_book.title).to eq old_title
        }

        it { expect(response).to have_http_status(:unprocessable_entity) }

        it { expect(response).to render_template(:edit) }
      end
    end
  end

  describe 'DELETE /books/:id' do
    include_examples 'requires login', :delete, -> { book_path(user_book) }

    context 'when logged in' do
      include_examples 'requires owner', :delete, -> { book_path(other_user_book) }

      it {
        expect do
          delete book_path(user_book)
        end.to change(Book, :count).by(-1)
      }

      it {
        delete book_path(user_book)
        expect(response).to redirect_to(books_path)
      }
    end
  end
end
