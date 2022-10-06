Rails.application.routes.draw do
  root 'categories#index'
  resources :categories
  devise_for :users
end
