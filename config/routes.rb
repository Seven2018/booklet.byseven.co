Rails.application.routes.draw do
  devise_for :users, path: 'u'
  resources :users
  resources :teams
  resources :companies
  resources :categories
  resources :skills
  resources :training_programs do
    resources :program_workshops, only: %i[create]
  end
  get 'training_programs-filter', to: 'training_programs#filter', as: 'filter_training_programs'
  resources :trainings do
    resources :training_workshops, only: %i[create update]
    get 'training_workshop/:id/copy', to: 'training_workshops#copy', as: 'copy_training_workshop'
  end
  resources :workshops do
    resources :workshop_skills, only: %i[create]
    resources :workshop_categories, only: %i[create]
  end
  get 'workshops-filter', to: 'workshops#filter', as: 'filter_workshops'
  resources :attendees, only: %i[create destroy]
  resources :requests, only: %i[index show create update destroy]
  root to: 'pages#home'
  get 'dashboard', to: 'pages#dashboard', as: 'dashboard'
  get 'catalogue', to: 'pages#catalogue', as: 'catalogue'
  get 'catalogue-filter', to: 'pages#filter_catalogue', as: 'filter_catalogue'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
