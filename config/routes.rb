Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :flashcard_sets, path: 'sets', except: [:new, :edit] do
    resources :flashcards, only: [:index, :create]
    member do
      post :comment  
      get :cards     
    end
  end

  resources :users, only: [:index, :create]

  root 'flashcard_sets#index'
end
