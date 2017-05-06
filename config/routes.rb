Rails.application.routes.draw do

  get 'inside' => 'sessions#new', :as => 'inside'
  get 'outside' => 'sessions#destroy', :as => 'outside'
  get 'fms' => 'users#new', :as => 'fms'
  resources :users
  resources :sessions
  resources :projects
  resources :blog

  root 'hall#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
