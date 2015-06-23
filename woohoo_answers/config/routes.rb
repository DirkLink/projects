Rails.application.routes.draw do
  resources :questions
  resources :answers, except: [:index, :show]
end
