Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }


  namespace :admin do
    resource :settings, only: [:edit, :update]
  end
  
  resources :collections do
    get 'random', on: :collection
    resources :flashcard_sets 
    resources :favorites, only: [:create, :destroy]
  end

  resources :flashcard_sets, path: 'sets', except: [:new] do
    resources :flashcards do
      post 'hide', on: :member
      post 'unhide', on: :member
    end
    
    resources :comments, only: [:create, :edit, :update, :destroy]

    member do
      post :comment  
      get :cards     
    end
  end

  resources :users, only: [:index, :show, :update] do 
    member do
      get 'collections', to: 'users#collections'
      post 'collections', to: 'users#create_collection'
      get 'collections/:collection_id', to: 'users#show_collection'
      put 'collections/:collection_id', to: 'users#update_collection'
      delete 'collections/:collection_id', to: 'users#destroy_collection'
    end
    resources :collections
  end
  
  get '/favorites', to: 'collections#favorites', as: 'favorites'
  get '/collection/all_collections', to: 'collections#all_collections', as: 'all_collections'
  get '/users/:user_id/sets', to: 'users#flashcard_sets'
  root 'collections#index'
end
