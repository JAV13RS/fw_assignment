Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :flashcard_sets, path: 'sets', except: [:new, :edit] do
    resources :flashcards, only: [:index, :create]
    
    member do
      post :comment  
      get :cards     
    end
  end

  resources :users, only: [:index, :show, :update] do 
    

    resources :collections
  end
  
  get 'collections', to: 'users#collections'
    post 'collections', to: 'users#create_collection'
    get 'collections/:collection_id', to: 'users#show_collection'
    put 'collections/:collection_id', to: 'users#update_collection'
    delete 'collections/:collection_id', to: 'users#destroy_collection'
  get '/users/:user_id/sets', to: 'users#flashcard_sets'
  
  root 'flashcard_sets#index'
end
