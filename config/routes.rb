Rails.application.routes.draw do
  devise_for :users, path: 'u', controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users
  post 'users/import', to: 'users#import', as: 'import_users'
  resources :teams, only: %i[create show update destroy]
  resources :team_categories, only: %i[create]
  resources :user_teams, only: %i[create]
  resources :companies
  resources :categories
  resources :skills
  resources :training_programs do
    resources :program_workshops, only: %i[create]
    get 'program_workshop/:id/move_up', to: "program_workshops#move_up", as: "move_up_program_workshop"
    get 'program_workshop/:id/move_down', to: "program_workshops#move_down", as: "move_down_program_workshop"
    resources :program_categories, only: %i[create]
  end
  get 'training_programs-filter', to: 'training_programs#filter', as: 'filter_training_programs'
  resources :trainings, only: %i[show create update destroy]
  resources :training_workshops, only: %i[show create update destroy]
  get 'training_workshop/:id/copy', to: 'training_workshops#copy', as: 'copy_training_workshop'
  post 'training_workshops/book', to: 'training_workshops#book_training_workshop', as: 'book_training_workshop'
  get 'training_workshops/:id/viewmode', to: 'training_workshops#view_mode', as: 'view_training_workshop'
  resources :workshops, only: %i[show new create edit update destroy] do
    resources :workshop_skills, only: %i[create]
    resources :workshop_categories, only: %i[create]
  end
  get 'workshops-filter', to: 'workshops#filter', as: 'filter_workshops'
  get 'workshops/:id/viewmode', to: 'workshops#view_mode', as: 'view_workshop'
  resources :mods, only: %i[show new create update destroy]
  resources :workshop_mods, only: %i[create destroy]
  resources :training_workshop_mods, only: %i[create destroy]
  resources :attendees, only: %i[create update destroy]
  get 'attendee-create-all', to: 'attendees#create_all', as: 'create_all_attendees'
  get 'attendee-destroy-all', to: 'attendees#destroy_all', as: 'destroy_all_attendees'
  get 'attendee-confirm-training', to: 'attendees#confirm_training', as: 'confirm_training_attendees'
  get 'attendee-confirm-workshop', to: 'attendees#confirm_training_workshop', as: 'confirm_training_workshop_attendees'
  post 'attendee-invite-to-workshop', to: 'attendees#invite_user_to_workshop', as: 'invite_to_workshop_attendees'
  post 'attendee-invite-to-training', to: 'attendees#invite_user_to_training', as: 'invite_to_training_attendees'
  post 'attendee-mark-as-completed', to: 'attendees#mark_as_completed', as: 'mark_as_completed_attendees'
  resources :requests, only: %i[index show create update destroy]
  root to: 'pages#dashboard'
  get 'dashboard', to: 'pages#dashboard', as: 'dashboard'
  get 'dashboard-calendar', to: 'pages#calendar', as: 'dashboard_calendar'
  get 'catalogue', to: 'pages#catalogue', as: 'catalogue'
  get 'catalogue-filter-workshop', to: 'pages#catalogue_filter_workshop', as: 'filter_workshop_catalogue'
  get 'catalogue-filter-program', to: 'pages#catalogue_filter_program', as: 'filter_program_catalogue'
  get 'catalogue_workshops_title_order_asc', to: 'pages#catalogue_workshops_title_order_asc', as: 'catalogue_workshops_title_order_asc'
  get 'catalogue_workshops_title_order_desc', to: 'pages#catalogue_workshops_title_order_desc', as: 'catalogue_workshops_title_order_desc'
  get 'catalogue_workshops_type_order_asc', to: 'pages#catalogue_workshops_type_order_asc', as: 'catalogue_workshops_type_order_asc'
  get 'catalogue_workshops_type_order_desc', to: 'pages#catalogue_workshops_type_order_desc', as: 'catalogue_workshops_type_order_desc'
  get 'catalogue_workshops_duration_order_asc', to: 'pages#catalogue_workshops_duration_order_asc', as: 'catalogue_workshops_duration_order_asc'
  get 'catalogue_workshops_duration_order_desc', to: 'pages#catalogue_workshops_duration_order_desc', as: 'catalogue_workshops_duration_order_desc'
  get 'catalogue_programs_title_order_asc', to: 'pages#catalogue_programs_title_order_asc', as: 'catalogue_programs_title_order_asc'
  get 'catalogue_programs_title_order_desc', to: 'pages#catalogue_programs_title_order_desc', as: 'catalogue_programs_title_order_desc'
  get 'catalogue_programs_duration_order_asc', to: 'pages#catalogue_programs_duration_order_asc', as: 'catalogue_programs_duration_order_asc'
  get 'catalogue_programs_duration_order_desc', to: 'pages#catalogue_programs_duration_order_desc', as: 'catalogue_programs_duration_order_desc'
  get 'statistics', to: 'pages#statistics', as: 'statistics'
  get 'organisation', to: 'pages#organisation', as: 'organisation'
  get 'notification-mark-as-read', to: 'notifications#mark_as_read', as: 'mark_as_read_notifications'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/redirect', to: 'attendees#redirect', as: 'redirect'
  get '/callback', to: 'attendees#callback', as: 'callback'
  get '/calendars', to: 'attendees#calendars', as: 'calendars'
end
