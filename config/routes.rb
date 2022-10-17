Rails.application.routes.draw do
  root 'categories#index'
  resources :categories
  resources :books
  devise_for :users
end
