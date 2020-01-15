Rails.application.routes.draw do
  devise_for :users, path: 'u'
  resources :users
  resources :companies
  resources :categories
  resources :skills
  resources :training_programs
  resources :trainings
  resources :workshops
  resources :attendees, only: %i[create destroy]
  resources :requests, only: %i[index show create update destroy]
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
