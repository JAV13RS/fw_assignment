Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }


  resources :collections do
    get 'random', on: :collection
    resources :flashcard_sets 
  end

  resources :flashcard_sets, path: 'sets', except: [:new] do
    resources :flashcards, only: [:new, :create, :edit, :update, :destroy, :show]
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
  
  get '/collection/all_collections', to: 'collections#all_collections', as: 'all_collections'
  get '/users/:user_id/sets', to: 'users#flashcard_sets'
  root 'collections#index'
end
