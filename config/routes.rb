Rails.application.routes.draw do

  # ASSESSMENTS
  resources :assessments, only: %i[] do
    resources :assessment_questions, only: %i[destroy]
    get 'question/:id/view_mode', to: 'assessment_questions#view_mode', as: 'view_mode_assessment_question'
    get 'question/:id/move_up', to: 'assessment_questions#move_up', as: 'move_up_assessment_question'
    get 'question/:id/move_down', to: 'assessment_questions#move_down', as: 'move_down_assessment_question'
  end
  post 'assessments/create_ajax', to: 'assessments#create_ajax', as: 'create_ajax_assessment'
  post 'assessments/:id/add_questions', to: 'assessments#add_questions', as: 'add_questions_assessment'
  patch 'assessments/:id/assessment_questions/:id/edit', to: 'assessments#edit_question', as: 'edit_question_assessment'
  post 'assessments/:id/add_answers', to: 'assessments#add_answers', as: 'add_answers_assessment'

  get 'contents-filter', to: 'contents#filter', as: 'filter_contents'
  get 'contents/:id/viewmode', to: 'contents#view_mode', as: 'view_content'

  # ATTENDEES
  resources :attendees, only: %i[]

  # CATEGORIES
  resources :categories, only: %i[create update destroy]
  get :categories_search, controller: :categories

  # COMPANIES
  resources :companies, only: %i[new create update destroy]

  # CONTENTS
  resources :contents, only: %i[show create update] do
    # resources :content_skills, only: %i[create]
  end
  get :change_author, controller: :contents
  get :content_link_category, controller: :contents
  get :destroy_content, controller: :contents
  get 'contents/:id/edit_mode', to: 'contents#edit_mode', as: 'edit_mode_content'
  get 'contents/:id/duplicate', to: 'contents#duplicate', as: 'duplicate_content'

  #MODS
  resources :mods, only: %i[create update destroy]
  get 'mods/:id/move_up', to: 'mods#move_up', as: 'move_up_mod'
  get 'mods/:id/move_down', to: 'mods#move_down', as: 'move_down_mod'

  # PAGES
  root to: redirect('/dashboard')
  get 'dashboard', to: 'pages#dashboard', as: 'dashboard'
  get 'catalogue', to: 'pages#catalogue', as: 'catalogue'
  get 'organisation', to: 'pages#organisation', as: 'organisation'
  get 'book', to: 'pages#book', as: 'book'
  get :recommendation, controller: :pages
  get :catalogue_content_link_category, controller: :pages
  get :overview, controller: :pages
  # NOT (USED)
  # get :organisation_user_card, controller: :pages

  # SESSIONS
  resources :sessions, only: %i[update destroy]
  get :book_sessions, controller: :sessions

  # SKILLS (NOT USED)
  # resources :skills
  # resources :training_contents, only: %i[show create update destroy]
  # get 'training_contents/:id/copy', to: 'training_contents#copy', as: 'copy_training_content'
  # get 'training_contents/:id/viewmode', to: 'training_contents#view_mode', as: 'view_training_content'

  # TAG CATEGORIES
  resources :tag_categories, only: %i[create destroy]
  get :update_tag_category, controller: :tag_categories

  # TAGS
  resources :tags, only: %i[create destroy]
  get :update_tag, controller: :tags

  # USER_INTERESTS
  resources :user_interests, only: %i[create destroy]
  get :complete_content, controller: :user_interests
  get :recommend, controller: :user_interests
  get :recommend_all, controller: :user_interests
  get :update_recommendation, controller: :user_interests

  # USER TAGS
  resources :user_tags, only: %i[create]

  # USERS
  devise_for :users, path: 'u', controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    match '/sessions/user', to: 'devise/sessions#create', via: :post
  end
  resources :users, only: %i[create show update destroy]
  get :complete_profile, controller: :users
  get :link_to_company, controller: :users
  post :import_users, controller: :users
  get :users_search, controller: :users
end
