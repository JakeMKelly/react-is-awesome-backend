Rails.application.routes.draw do
  resources :users, except: [:new, :index, :destroy, :show]
  resources :sessions, only: [:create, :destroy]

  resources :foods, except: :update
  resources :books, except: :update
  get '/books/search/:term', to: 'books#search'
  resources :users do
    resources :books, except: [:create, :show, :new]
  end
  resources :products, only: :index
end
