Rails.application.routes.draw do
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad

  require 'sidekiq/web'
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  if ENV['CANONICAL_HOST']
    constraints(:host => Regexp.new("^(?!#{Regexp.escape(ENV['CANONICAL_HOST'])})")) do
      match "/(*path)" => redirect { |params, req| "https://#{ENV['CANONICAL_HOST']}/#{params[:path]}" },  via: [:get, :post]
    end
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
    resources :interview_sets, only: %i[create update destroy]
  end
  resources :campaigns, only: %i[index show update destroy] do
    collection do
      get :list
    end
    member do
      get :overview
      post :search_tags
      post :toggle_tag
      delete :remove_company_tag
      get :index_line
      get :data_show
    end
    collection do
      get :redirect_calendar
      get :update_calendar
    end
  end
  get :my_interviews, controller: :campaigns
  get :my_interviews_list, controller: :campaigns
  get :my_team_interviews, controller: :campaigns
  get :my_team_interviews_list, controller: :campaigns
  match '/send_notification_email/:id' => 'campaigns#send_notification_email', as: :send_notification_email, via: [:get]
  get :campaign_select_owner, controller: :campaigns
  get :campaign_edit_date, controller: :campaigns

  namespace :interviews do
    resource :reports, only: %i[edit update]
    resources :reports, only: %i[index show destroy] do
      collection do
        get :list
      end
    end
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
    namespace :templates do
      resources :tags, only: :index
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
  get :categories_search, controller: :categories
  resources :categories, only: [:index, :update] do
    collection do
      get :from_campaign
      get :from_template
      get :groups
      post :new_group
      get :search_v2
    end
  end
  resources :group_categories, only: [:destroy, :update]

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
  get :lock_interview, controller: :interviews
  get :unlock_interview, controller: :interviews
  get :show_crossed_and_lock, controller: :interviews
  get :archive_interview, controller: :interviews
  get :archive_interviewer_interviews, controller: :interviews

  namespace :interview do
    namespace :answer do
      resource :authorization_checks, only: :create
    end
  end

  post :answer_question, controller: :interviews, as: :answer_interview_question

  # INTERVIEW FORMS
  resources :interview_forms do
    collection do
      get :list
    end
    member do
      post 'search_tags'
      post 'toggle_tag'
      delete 'remove_company_tag'
      get 'index_line'
    end
  end
  get 'interview_forms/:id/duplicate', to: 'interview_forms#duplicate', as: 'duplicate_interview_form'
  get :templates_search, controller: :interview_forms

  # INTERVIEW QUESTIONS
  resources :interview_questions
  post :create_interview_mcq, controller: :interview_questions
  post :add_mcq_option, controller: :interview_questions
  patch :edit_mcq_option, controller: :interview_questions
  patch :delete_mcq_option, controller: :interview_questions
  get 'interview_questions/:id/duplicate', to: 'interview_questions#duplicate', as: 'duplicate_interview_question'
  get 'interview_questions/:id/move_up', to: 'interview_questions#move_up', as: 'move_up_interview_question'
  get 'interview_questions/:id/move_down', to: 'interview_questions#move_down', as: 'move_down_interview_question'

  # MODS
  resources :mods, only: %i[create update destroy]
  post :duplicate, controller: :mods, as: :duplicate_mod
  get 'mods/:id/move_up', to: 'mods#move_up', as: 'move_up_mod'
  get 'mods/:id/move_down', to: 'mods#move_down', as: 'move_down_mod'

  # OBJECTIVES
  namespace :objective do
    resources :elements do
      collection do
        get :list
        get :target_list
      end
      member do
        post :archive
        post :unarchive
      end
    end
    get :my_objectives, controller: :elements
    get :my_team_objectives, controller: :elements
    get :targets, controller: :elements
    get :employees, controller: :elements
    resources :indicators, only: %i[update destroy]
    resources :logs
    resources :users, only: [:index, :show] do
      member do
        get :info
        get :list_current
        get :list_archived
        get :my_team_objectives
        get :my_team_objectives_current_list
        get :my_team_objectives_archived_list
      end
    end
    resources :templates do
      collection do
        get :list
        get :new_target_view
      end
    end
  end

  # PAGES
  get :home, controller: :pages
  get :catalogue, controller: :pages
  get :organisation, controller: :pages
  post :create_tag_category_tags, controller: :pages

  # get :recommendation, controller: :pages # NOT USED ATM

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
    match '/sessions/user', to: 'users/sessions#create', via: :post
    post '/u/check', to: 'users/sessions#check', via: :post
    get '/u/resend_email', to: 'users/sessions#resend_email'
  end

  resources :users, only: %i[create show update destroy edit] do
    member do
      post 'add_tag_category_tags'
    end
    resource :permissions, only: %i[edit update]
  end

  get :complete_profile, controller: :users
  get :link_to_company, controller: :users
  get :unlink_from_company, controller: :users
  post :import_users, controller: :users
  get :users_search, controller: :users
  get :campaign_draft_users, controller: :users
  get :managers_search, controller: :users

  # WORKSHOPS
  resources :workshops, only: %i[show edit update]
  get :complete_workshop, controller: :workshops

  # design pages
  get '/design', to: 'design#index'
  get '/guidelines', to: 'design#guidelines'
end
