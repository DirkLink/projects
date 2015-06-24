Rails.application.routes.draw do
  devise_for :users
  resources :questions
  resources :answers, except: [:index, :show]

  root 'questions#index'
end
