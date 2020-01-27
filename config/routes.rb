Rails.application.routes.draw do
  devise_for :users, path: 'u'
  resources :users
  resources :teams, only: %i[create show update destroy]
  resources :team_categories, only: %i[create]
  resources :user_teams, only: %i[create]
  resources :companies
  resources :categories
  resources :skills
  resources :training_programs do
    resources :program_workshops, only: %i[create]
    resources :program_categories, only: %i[create]
  end
  get 'training_programs-filter', to: 'training_programs#filter', as: 'filter_training_programs'
  resources :trainings
  resources :training_workshops, only: %i[show create update destroy]
  get 'training_workshop/:id/copy', to: 'training_workshops#copy', as: 'copy_training_workshop'
  post 'training_workshops/book', to: 'training_workshops#book_training_workshop', as: 'book_training_workshop'
  resources :workshops do
    resources :workshop_skills, only: %i[create]
    resources :workshop_categories, only: %i[create]
  end
  get 'workshops-filter', to: 'workshops#filter', as: 'filter_workshops'
  resources :mods, only: %i[show create update destroy]
  resources :workshop_mods, only: %i[create destroy]
  resources :training_workshop_mods, only: %i[create destroy]
  resources :attendees, only: %i[create destroy]
  get 'attendee-create-all', to: 'attendees#create_all', as: 'create_all_attendees'
  get 'attendee-destroy-all', to: 'attendees#destroy_all', as: 'destroy_all_attendees'
  get 'attendee-confirm-training', to: 'attendees#confirm_training', as: 'confirm_training_attendees'
  get 'attendee-confirm-workshop', to: 'attendees#confirm_training_workshop', as: 'confirm_training_workshop_attendees'
  post 'attendee-invite-to-workshop', to: 'attendees#invite_user_to_workshop', as: 'invite_to_workshop_attendees'
  post 'attendee-invite-to-training', to: 'attendees#invite_user_to_training', as: 'invite_to_training_attendees'
  post 'attendee-mark-as-completed', to: 'attendees#mark_as_completed', as: 'mark_as_completed_attendees'
  resources :requests, only: %i[index show create update destroy]
  root to: 'pages#home'
  get 'dashboard', to: 'pages#dashboard', as: 'dashboard'
  get 'catalogue', to: 'pages#catalogue', as: 'catalogue'
  get 'statistics', to: 'pages#statistics', as: 'statistics'
  get 'catalogue-filter', to: 'pages#filter_catalogue', as: 'filter_catalogue'
  get 'organisation', to: 'pages#organisation', as: 'organisation'
  get 'notification-mark-as-read', to: 'notifications#mark_as_read', as: 'mark_as_read_notifications'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
