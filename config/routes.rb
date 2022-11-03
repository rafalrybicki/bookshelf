Rails.application.routes.draw do
  root 'books#index'
  resources :categories
  resources :books
  devise_for :users
end
