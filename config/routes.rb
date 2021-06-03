Rails.application.routes.draw do
  # COMPANIES
  resources :companies

  # USERS
  devise_for :users, path: 'u', controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: %i[new create show update destroy]
  post 'users/import', to: 'users#import', as: 'import_users'
  get :users_search, controller: :users

  # TAG CATEGORIES
  resources :tag_categories, only: %i[create destroy]
  get :update_tag_category, controller: :tag_categories

  # TAGS
  resources :tags, only: %i[create show update destroy]
  get :update_tag, controller: :tags

  # USER TAGS
  resources :user_tags, only: %i[create]

  # CATEGORIES
  resources :categories
  get :categories_search, controller: :categories

  # SKILLS
  resources :skills
  resources :training_contents, only: %i[show create update destroy]
  get 'training_contents/:id/copy', to: 'training_contents#copy', as: 'copy_training_content'
  get 'training_contents/:id/viewmode', to: 'training_contents#view_mode', as: 'view_training_content'

  # CONTENTS
  resources :contents, only: %i[show new create edit update destroy] do
    resources :content_skills, only: %i[create]
  end
  post 'contents/create_content', to: 'contents#create_content', as: 'create_content'
  patch 'contents/:id/update_content', to: 'contents#update_content', as: 'update_content'
  get :change_author, controller: :contents
  get :add_category, controller: :contents
  get :content_link_category, controller: :contents
  get 'contents/:id/duplicate', to: 'contents#duplicate', as: 'duplicate_content'

  # USER_INTERESTS
  resources :user_interests, only: %i[create destroy]

  # ASSESSMENTS
  resources :assessments, only: %i[show new create edit update destroy] do
    resources :assessment_questions, only: %i[update destroy]
    get 'question/:id/view_mode', to: 'assessment_questions#view_mode', as: 'view_mode_assessment_question'
    get 'question/:id/move_up', to: 'assessment_questions#move_up', as: 'move_up_assessment_question'
    get 'question/:id/move_down', to: 'assessment_questions#move_down', as: 'move_down_assessment_question'
  end
  post 'assessments/:id/add_questions', to: 'assessments#add_questions', as: 'add_questions_assessment'
  # get 'assessments/:id/view_mode', to: 'assessments#view_mode', as: 'view_mode_assessment'
  post 'assessments/:id/add_answers', to: 'assessments#add_answers', as: 'add_answers_assessment'
  post 'assessments/create_ajax', to: 'assessments#create_ajax', as: 'create_ajax_assessment'
  patch 'assessments/:id/update_ajax', to: 'assessments#update_ajax', as: 'update_ajax_assessment'
  post 'assessments/:id/add_questions_ajax', to: 'assessments#add_questions_ajax', as: 'add_questions_ajax_assessment'

  get 'contents-filter', to: 'contents#filter', as: 'filter_contents'
  get 'contents/:id/viewmode', to: 'contents#view_mode', as: 'view_content'
  resources :mods, only: %i[show new create update destroy]
  post :create_mod, controller: :mods
  post 'mods/:id/update_mod', to: 'mods#update_mod', as: 'update_mod'
  resources :content_mods, only: %i[create destroy]
  get 'content_mods/:id/move_up', to: 'content_mods#move_up', as: 'move_up_content_mod'
  get 'content_mods/:id/move_down', to: 'content_mods#move_down', as: 'move_down_content_mod'
  post 'content_mods/create_ajax', to: 'content_mods#create_ajax', as: 'create_ajax_content_mods'
  resources :attendees, only: %i[create update destroy]
  get 'attendee-create-all', to: 'attendees#create_all', as: 'create_all_attendees'
  get 'attendee-destroy-all', to: 'attendees#destroy_all', as: 'destroy_all_attendees'
  get 'attendee-confirm-training', to: 'attendees#confirm_training', as: 'confirm_training_attendees'
  get 'attendee-confirm-content', to: 'attendees#confirm_training_content', as: 'confirm_training_content_attendees'
  post 'attendee-invite-to-content', to: 'attendees#invite_user_to_content', as: 'invite_to_content_attendees'
  post 'attendee-invite-to-training', to: 'attendees#invite_user_to_training', as: 'invite_to_training_attendees'
  post 'attendee-mark-as-completed', to: 'attendees#mark_as_completed', as: 'mark_as_completed_attendees'

  # PAGES
  root to: redirect('/dashboard')
  get 'dashboard', to: 'pages#dashboard', as: 'dashboard'
  get 'catalogue', to: 'pages#catalogue', as: 'catalogue'
  get 'organisation', to: 'pages#organisation', as: 'organisation'
  get :catalogue_content_link_category, controller: :pages
  get :catalogue_filter_add_category, controller: :pages
  get 'book', to: 'pages#book', as: 'book'

  # SESSIONS
  get :book_sessions, controller: :sessions
  get :book_sessions_update, controller: :sessions

  # CALENDAR
  get '/redirect', to: 'attendees#redirect', as: 'redirect'
  get '/callback', to: 'attendees#callback', as: 'callback'
  get '/calendars', to: 'attendees#calendars', as: 'calendars'
end
