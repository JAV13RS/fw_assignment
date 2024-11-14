Rails.application.routes.draw do
  devise_for :users

  resources :flashcard_sets, path: 'sets', except: [:new, :edit] do
    resources :flashcards, only: [:index, :create]
    post 'comment', on: :member  
  end

end
