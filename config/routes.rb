Rails.application.routes.draw do
  devise_for :users
  
  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :flashcard_sets, path: 'sets', except: [:new, :edit] do
    resources :flashcards, only: [:index, :create]
  end
end
