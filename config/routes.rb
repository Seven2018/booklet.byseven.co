Rails.application.routes.draw do
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad

  require 'sidekiq/web'
  authenticate :user, ->(u) { u.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  root to: 'pages#home'

  # ASSESSMENTS
  resources :assessments, only: %i[] do

  end
  post 'assessments/create_ajax', to: 'assessments#create_ajax', as: 'create_ajax_assessment'
  post 'assessments/:id/add_questions', to: 'assessments#add_questions', as: 'add_questions_assessment'
  patch 'assessments/:id/assessment_questions/:id/edit', to: 'assessments#edit_question', as: 'edit_question_assessment'
  post 'assessments/:id/add_answers', to: 'assessments#add_answers', as: 'add_answers_assessment'

  get 'contents-filter', to: 'contents#filter', as: 'filter_contents'
  get 'contents/:id/viewmode', to: 'contents#view_mode', as: 'view_content'

  # ASSESSMENT QUESTIONS
  resources :assessment_questions

  # ATTENDEES
  resources :attendees

  # CAMPAIGNS
  namespace :campaigns do
    # must stay before resources :campaigns
    resources :users, only: :index
    resources :interview_sets, only: %i[create destroy]
  end
  resources :campaigns, only: %i[index show destroy]
  get :my_interviews, controller: :campaigns
  get :my_team_interviews, controller: :campaigns
  get :send_notification_email, controller: :campaigns
  get :campaign_select_owner, controller: :campaigns
  get :campaign_edit_date, controller: :campaigns

  namespace :interviews do
    resource :reports, only: %i[edit update]
    resources :reports, only: %i[index show destroy]
    namespace :report do
      resources :campaigns, only: :index
      resource :campaigns, only: :update
    end
  end

  namespace :trainings do
    resource :reports, only: %i[edit update]
    resources :reports, only: %i[index show destroy]
    namespace :report do
      resources :trainings, only: :index
      resource :trainings, only: :update
      resources :participants, only: :index
      resource :participants, only: :update
    end
  end

  namespace :campaign_draft do
    resource :settings, only: %i[edit update]
    resource :participants, only: %i[edit update]
    resource :templates, only: %i[edit update]
    resource :dates, only: %i[edit update]
    resource :launches, only: %i[edit update]
    namespace :interviewees do
      resources :users, only: :index
      resource :ids, only: :update
    end
  end

  namespace :training_draft do
    resource :participants, only: %i[edit update]
    resource :contents, only: %i[edit update]
    resource :dates, only: %i[edit update]
    resource :launches, only: %i[edit update]

    namespace :participants do
      resources :users, only: :index
      resource :ids, only: :update
    end
    namespace :contents do
      resources :contents, only: :index
    end
    namespace :dates do
      resources :time_slot_forms, only: :create
    end
  end

  # CATEGORIES
  resources :categories, only: %i[create update destroy]
  get :categories_search, controller: :categories

  # COMPANIES
  resources :companies, only: %i[new create update destroy]

  # CONTENTS
  resources :contents, only: %i[create show edit update destroy] do
    # resources :content_skills, only: %i[create]
  end
  get :content_link_category, controller: :contents
  get 'contents/:id/duplicate', to: 'contents#duplicate', as: 'duplicate_content'

  # FOLDERS
  resources :folders
  get :folder_link_category, controller: :folders
  get :folder_manage_children, controller: :folders
  get 'folders/:id/duplicate', to: 'folders#duplicate', as: 'duplicate_folder'

  # INTERVIEWS
  resources :interviews do
    resource :locks, module: :interview, only: :create
  end
  get :complete_interview, controller: :interviews
  get :lock_interview, controller: :interviews
  get :unlock_interview, controller: :interviews
  get :show_crossed_and_lock, controller: :interviews

  namespace :interview do
    namespace :answer do
      resource :authorization_checks, only: :create
    end
  end

  post :answer_question, controller: :interviews, as: :answer_interview_question

  # INTERVIEW FORMS
  resources :interview_forms do
    member do
      post 'toggle_tag'
      delete 'remove_company_tag'
    end
  end
  get :interview_form_link_tags, controller: :interview_forms
  get 'interview_forms/:id/duplicate', to: 'interview_forms#duplicate', as: 'duplicate_interview_form'

  # INTERVIEW QUESTIONS
  resources :interview_questions
  post :create_interview_mcq, controller: :interview_questions
  post :add_mcq_option, controller: :interview_questions
  patch :edit_mcq_option, controller: :interview_questions
  patch :delete_mcq_option, controller: :interview_questions
  get 'interview_questions/:id/duplicate', to: 'interview_questions#duplicate', as: 'duplicate_interview_question'
  get 'interview_questions/:id/move_up', to: 'interview_questions#move_up', as: 'move_up_interview_question'
  get 'interview_questions/:id/move_down', to: 'interview_questions#move_down', as: 'move_down_interview_question'

  #MODS
  resources :mods, only: %i[create update destroy]
  post :duplicate, controller: :mods, as: :duplicate_mod
  get 'mods/:id/move_up', to: 'mods#move_up', as: 'move_up_mod'
  get 'mods/:id/move_down', to: 'mods#move_down', as: 'move_down_mod'

  # PAGES
  get :home, controller: :pages
  get :catalogue, controller: :pages
  get :organisation, controller: :pages

  get :book_contents, controller: :pages # TODO deprecate => replaced by training_draft
  get :book_users, controller: :pages # TODO deprecate => replaced by training_draft
  get :book_dates, controller: :pages # TODO deprecate => replaced by training_draft
  get :recommendation, controller: :pages
  get :catalogue_content_link_category, controller: :pages
  # NOT (USED)
  # get :organisation_user_card, controller: :pages

  # TRAININGS
  resources :trainings
  get :my_trainings, controller: :trainings
  get :my_team_trainings, controller: :trainings
  get 'my_team_trainings/users/:id', to: 'trainings#my_team_trainings_user_details', as: 'my_team_trainings_user_details'
  get :send_acquisition_reminder_email, controller: :trainings

  # SESSIONS
  resources :sessions, only: %i[update destroy]
  get :book_sessions, controller: :sessions

  resources :impersonations, only: [:index] do
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
  end

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
  get :tags_search, controller: :tags

  # USER_INTERESTS
  resources :user_interests, only: %i[create destroy]
  # get :complete_content, controller: :user_interests
  post :recommend, controller: :user_interests
  get :update_recommendation, controller: :user_interests

  # USER TAGS
  resources :user_tags, only: %i[create]

  # USERS
  devise_for :users, path: 'u', controllers: {
    sessions: 'users/sessions',
    invitations: 'users/invitations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_scope :user do
    match '/sessions/user', to: 'devise/sessions#create', via: :post
    post '/u/check', to: 'users/sessions#check', via: :post
    get '/u/resend_email', to: 'users/sessions#resend_email'
  end
  resources :users, only: %i[create show update destroy]
  get :complete_profile, controller: :users
  get :link_to_company, controller: :users
  get :unlink_from_company, controller: :users
  post :import_users, controller: :users
  get :users_search, controller: :users
  get :campaign_draft_users, controller: :users

  # WORKSHOPS
  resources :workshops, only: %i[show edit update]
  get :complete_workshop, controller: :workshops

  # design pages
  get '/design', to: 'design#index'
  get '/guidelines', to: 'design#guidelines'
end
