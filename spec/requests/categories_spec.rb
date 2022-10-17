require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  let(:user) { FactoryBot.create :user }
  let(:other_user) { FactoryBot.create :user }
  let!(:user_category) { FactoryBot.create :category, owner_id: user.id }
  let(:other_user_category) { FactoryBot.create :category, owner_id: other_user.id }
  let!(:book) { FactoryBot.create(:book, owner_id: user.id, categories: [user_category.id]) }
  let!(:other_book) { FactoryBot.create(:book) }
  let(:valid_parameters) { { category: { name: 'category_name' } } }
  let(:invalid_parameters) { { category: { name: nil } } }

  before do
    sign_in user
  end

  describe 'GET #index' do
    include_examples 'requires login', :get, -> { categories_path }

    context 'when logged in' do
      it "renders 'index' template" do
        get categories_path
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end

      it 'displays only the categories of a specific user' do
        get categories_path
        expect(response.body).to include(user_category.name)
        expect(response.body).to_not include(other_user_category.name)
      end
    end
  end

  describe 'GET #show' do
    include_examples 'requires login', :get, -> { category_path(user_category) }

    context 'when logged in' do
      include_examples 'requires owner', :get, -> { category_path(other_user_category) }

      it "renders 'show' template" do
        get category_path(user_category)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
        expect(response.body).to include(user_category.name)
      end

      it 'returns related books' do
        get category_path(user_category)
        expect(response.body).to include(book.title)
      end
    end
  end

  describe 'GET #new' do
    include_examples 'requires login', :get, -> { new_category_path }

    context 'when logged in' do
      it "renders 'new' template" do
        get '/categories/new'
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    include_examples 'requires login', :post, -> { categories_path(valid_parameters) }

    context 'when logged in' do
      context 'with valid parameters' do
        it 'creates a new Category' do
          expect do
            post categories_path(valid_parameters)
          end.to change(Category, :count).by(1)
        end

        it 'redirects to the created cateogry' do
          post categories_path(valid_parameters)
          expect(response).to redirect_to(category_path(Category.last))
        end

        it "renders 'show' template" do
          post categories_path(valid_parameters)
          expect(response).to have_http_status(:redirect)
          follow_redirect!
          expect(response).to render_template(:show)
          expect(response.body).to include(Category.last.name)
        end
      end

      context 'with invalid parameters' do
        it "doesn't create a new Category" do
          expect do
            post categories_path(invalid_parameters)
          end.to change(Category, :count).by(0)
        end

        it "renders 'new' template" do
          post categories_path(invalid_parameters)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'GET #edit' do
    include_examples 'requires login', :get, -> { edit_category_path(user_category) }

    context 'when logged in' do
      include_examples 'requires owner', :get, -> { edit_category_path(other_user_category) }

      it "renders 'edit' template" do
        get edit_category_path(user_category)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PATCH #update' do
    include_examples 'requires login', :patch, -> { category_path(user_category) }

    context 'when logged in' do
      include_examples 'requires owner', :patch, -> { category_path(other_user_category) }

      context 'with valid parameters' do
        let(:new_category_name) { valid_parameters[:category][:name] }

        it 'updates the requested category' do
          patch category_path(user_category, valid_parameters)
          user_category.reload
          expect(user_category.name).to eq new_category_name
        end

        it 'redirects to the category' do
          patch category_path(user_category, valid_parameters)
          expect(response).to redirect_to(category_path(user_category))
        end

        it "renders 'show' template" do
          patch category_path(user_category, valid_parameters)
          follow_redirect!
          expect(response).to render_template(:show)
        end
      end

      context 'with invalid parameters' do
        it "doesn't update the requested category" do
          old_name = user_category.name
          patch category_path(user_category, invalid_parameters)
          user_category.reload
          expect(user_category.name).to eq old_name
        end

        it "renders 'edit' template" do
          patch category_path(user_category, invalid_parameters)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    include_examples 'requires login', :delete, -> { category_path(user_category) }

    context 'when logged in' do
      include_examples 'requires owner', :delete, -> { category_path(other_user_category) }

      it 'destroys the requested category' do
        expect do
          delete category_path(user_category)
        end.to change(Category, :count).by(-1)
      end

      it 'redirects to categories index' do
        delete category_path(user_category)
        expect(response).to redirect_to(categories_path)
      end
    end
  end
end
