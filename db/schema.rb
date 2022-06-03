# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_06_02_163642) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "assessment_answers", force: :cascade do |t|
    t.string "answer", default: "", null: false
    t.boolean "correct"
    t.bigint "assessment_question_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assessment_question_id"], name: "index_assessment_answers_on_assessment_question_id"
    t.index ["user_id"], name: "index_assessment_answers_on_user_id"
  end

  create_table "assessment_questions", force: :cascade do |t|
    t.string "question"
    t.text "options"
    t.string "question_type"
    t.integer "position"
    t.boolean "logic_jump", default: false
    t.boolean "active", default: true
    t.bigint "mod_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mod_id"], name: "index_assessment_questions_on_mod_id"
  end

  create_table "attendees", force: :cascade do |t|
    t.string "status", default: "Not completed", null: false
    t.string "calendar_uuid"
    t.bigint "user_id"
    t.bigint "session_id"
    t.bigint "creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_attendees_on_creator_id"
    t.index ["session_id"], name: "index_attendees_on_session_id"
    t.index ["user_id"], name: "index_attendees_on_user_id"
  end

  create_table "campaign_drafts", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "state", default: 0, null: false
    t.jsonb "data", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_campaign_drafts_on_user_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", default: ""
    t.bigint "owner_id"
    t.bigint "company_id"
    t.bigint "interview_form_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "campaign_type", default: 0, null: false
    t.index ["company_id"], name: "index_campaigns_on_company_id"
    t.index ["interview_form_id"], name: "index_campaigns_on_interview_form_id"
    t.index ["owner_id"], name: "index_campaigns_on_owner_id"
  end

  create_table "campaigns_categories", id: false, force: :cascade do |t|
    t.bigint "campaign_id"
    t.bigint "category_id"
    t.index ["campaign_id"], name: "index_campaigns_categories_on_campaign_id"
    t.index ["category_id"], name: "index_campaigns_categories_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "kind", default: 0
    t.index ["company_id"], name: "index_categories_on_company_id"
  end

  create_table "categories_interview_forms", id: false, force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "interview_form_id"
    t.index ["category_id"], name: "index_categories_interview_forms_on_category_id"
    t.index ["interview_form_id"], name: "index_categories_interview_forms_on_interview_form_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "logo"
    t.string "siret"
    t.string "auth_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "applications", default: [], array: true
    t.text "rating_logo", default: "<span class=\"iconify\" data-icon=\"clarity:star-solid\"></span>"
  end

  create_table "content_categories", force: :cascade do |t|
    t.bigint "content_id"
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_content_categories_on_category_id"
    t.index ["content_id"], name: "index_content_categories_on_content_id"
  end

  create_table "content_folder_links", force: :cascade do |t|
    t.bigint "folder_id"
    t.bigint "content_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["content_id"], name: "index_content_folder_links_on_content_id"
    t.index ["folder_id"], name: "index_content_folder_links_on_folder_id"
  end

  create_table "content_skills", force: :cascade do |t|
    t.bigint "skill_id"
    t.bigint "content_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["content_id"], name: "index_content_skills_on_content_id"
    t.index ["skill_id"], name: "index_content_skills_on_skill_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.integer "duration", default: 0, null: false
    t.text "description", default: "", null: false
    t.string "content_type", default: "Synchronous", null: false
    t.string "image", default: "", null: false
    t.decimal "cost", precision: 15, scale: 10, default: "0.0"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_contents_on_company_id"
  end

  create_table "csv_import_users", force: :cascade do |t|
    t.jsonb "data", default: {}, null: false
    t.integer "state", default: 0, null: false
    t.bigint "creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_csv_import_users_on_creator_id"
  end

  create_table "currents", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "folder_categories", force: :cascade do |t|
    t.bigint "folder_id"
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_folder_categories_on_category_id"
    t.index ["folder_id"], name: "index_folder_categories_on_folder_id"
  end

  create_table "folder_links", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "child_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_id"], name: "index_folder_links_on_child_id"
    t.index ["parent_id"], name: "index_folder_links_on_parent_id"
  end

  create_table "folders", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_folders_on_company_id"
  end

  create_table "interview_answers", force: :cascade do |t|
    t.text "answer", default: "", null: false
    t.text "comments"
    t.bigint "interview_id"
    t.bigint "interview_question_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "objective"
    t.index ["interview_id"], name: "index_interview_answers_on_interview_id"
    t.index ["interview_question_id"], name: "index_interview_answers_on_interview_question_id"
    t.index ["user_id"], name: "index_interview_answers_on_user_id"
  end

  create_table "interview_form_tags", force: :cascade do |t|
    t.string "tag_name", default: "", null: false
    t.bigint "interview_form_id"
    t.bigint "tag_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["interview_form_id"], name: "index_interview_form_tags_on_interview_form_id"
    t.index ["tag_id"], name: "index_interview_form_tags_on_tag_id"
  end

  create_table "interview_forms", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", default: ""
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "answerable_by", default: 0, null: false
    t.boolean "cross", default: false
    t.string "video"
    t.boolean "used", default: false, null: false
    t.index ["company_id"], name: "index_interview_forms_on_company_id"
  end

  create_table "interview_questions", force: :cascade do |t|
    t.string "question"
    t.text "description"
    t.text "options"
    t.string "question_type"
    t.integer "position"
    t.boolean "allow_comments", default: false
    t.bigint "interview_form_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "visible_for", default: 0, null: false
    t.integer "required_for", default: 0, null: false
    t.index ["interview_form_id"], name: "index_interview_questions_on_interview_form_id"
  end

  create_table "interview_reports", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.jsonb "data"
    t.integer "state", default: 0, null: false
    t.integer "mode", default: 0, null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "signature"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "creator_id"
    t.bigint "tag_category_id"
    t.jsonb "inputs", default: {}, null: false
    t.index ["company_id"], name: "index_interview_reports_on_company_id"
    t.index ["creator_id"], name: "index_interview_reports_on_creator_id"
    t.index ["tag_category_id"], name: "index_interview_reports_on_tag_category_id"
  end

  create_table "interviews", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", default: ""
    t.string "label", null: false
    t.date "date"
    t.time "starts_at"
    t.time "ends_at"
    t.bigint "interview_form_id"
    t.bigint "employee_id"
    t.bigint "creator_id"
    t.bigint "campaign_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "locked_at"
    t.bigint "interviewer_id"
    t.integer "status", default: 0
    t.text "archived_for"
    t.index ["campaign_id"], name: "index_interviews_on_campaign_id"
    t.index ["creator_id"], name: "index_interviews_on_creator_id"
    t.index ["employee_id"], name: "index_interviews_on_employee_id"
    t.index ["interview_form_id"], name: "index_interviews_on_interview_form_id"
    t.index ["interviewer_id"], name: "index_interviews_on_interviewer_id"
  end

  create_table "mods", force: :cascade do |t|
    t.string "title"
    t.text "text", default: ""
    t.string "link"
    t.string "document"
    t.string "video"
    t.string "image"
    t.string "mod_type", default: ""
    t.integer "position"
    t.integer "duration", default: 0, null: false
    t.bigint "company_id"
    t.integer "content_id"
    t.integer "workshop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_mods_on_company_id"
  end

  create_table "objective_elements", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", default: ""
    t.date "due_date"
    t.bigint "objectivable_id"
    t.string "objectivable_type"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.bigint "creator_id"
    t.boolean "template", default: false
    t.boolean "can_employee_edit", default: true
    t.boolean "can_employee_view", default: true
    t.index ["company_id"], name: "index_objective_elements_on_company_id"
    t.index ["creator_id"], name: "index_objective_elements_on_creator_id"
  end

  create_table "objective_indicators", force: :cascade do |t|
    t.integer "indicator_type", null: false
    t.integer "status", default: 0
    t.jsonb "options", default: {}, null: false
    t.bigint "objective_element_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["objective_element_id"], name: "index_objective_indicators_on_objective_element_id"
  end

  create_table "objective_logs", force: :cascade do |t|
    t.string "title", null: false
    t.text "comments"
    t.integer "log_type", default: 0, null: false
    t.string "initial_value"
    t.string "updated_value"
    t.bigint "owner_id"
    t.bigint "objective_element_id"
    t.bigint "objective_indicator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["objective_element_id"], name: "index_objective_logs_on_objective_element_id"
    t.index ["objective_indicator_id"], name: "index_objective_logs_on_objective_indicator_id"
    t.index ["owner_id"], name: "index_objective_logs_on_owner_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.date "date"
    t.date "available_date"
    t.time "starts_at"
    t.time "ends_at"
    t.decimal "cost", precision: 15, scale: 10
    t.bigint "training_id"
    t.bigint "workshop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["training_id"], name: "index_sessions_on_training_id"
    t.index ["workshop_id"], name: "index_sessions_on_workshop_id"
  end

  create_table "skill_groups", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.string "description", default: "", null: false
    t.bigint "skill_group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["skill_group_id"], name: "index_skills_on_skill_group_id"
  end

  create_table "tag_categories", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_tag_categories_on_company_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag_name", default: "", null: false
    t.string "image", default: "", null: false
    t.bigint "company_id"
    t.bigint "tag_category_id"
    t.integer "tag_category_position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_tags_on_company_id"
    t.index ["tag_category_id"], name: "index_tags_on_tag_category_id"
  end

  create_table "training_drafts", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "state", default: 0, null: false
    t.jsonb "data", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_training_drafts_on_user_id"
  end

  create_table "training_reports", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.jsonb "data", default: {}, null: false
    t.integer "state", default: 0, null: false
    t.integer "mode", default: 0, null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "signature"
    t.bigint "creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_training_reports_on_company_id"
    t.index ["creator_id"], name: "index_training_reports_on_creator_id"
  end

  create_table "trainings", force: :cascade do |t|
    t.string "title"
    t.bigint "company_id"
    t.bigint "folder_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "creator_id"
    t.index ["company_id"], name: "index_trainings_on_company_id"
    t.index ["creator_id"], name: "index_trainings_on_creator_id"
    t.index ["folder_id"], name: "index_trainings_on_folder_id"
  end

  create_table "user_forms", force: :cascade do |t|
    t.integer "grade"
    t.boolean "validated", default: false
    t.bigint "user_id"
    t.bigint "mod_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mod_id"], name: "index_user_forms_on_mod_id"
    t.index ["user_id"], name: "index_user_forms_on_user_id"
  end

  create_table "user_interests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "folder_id"
    t.bigint "content_id"
    t.string "status"
    t.string "recommendation"
    t.string "comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["content_id"], name: "index_user_interests_on_content_id"
    t.index ["folder_id"], name: "index_user_interests_on_folder_id"
    t.index ["user_id"], name: "index_user_interests_on_user_id"
  end

  create_table "user_skills", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "skill_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "user_tags", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "tag_id"
    t.bigint "tag_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_category_id"], name: "index_user_tags_on_tag_category_id"
    t.index ["tag_id"], name: "index_user_tags_on_tag_id"
    t.index ["user_id"], name: "index_user_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "firstname", default: "", null: false
    t.string "lastname", default: "", null: false
    t.date "birth_date"
    t.date "hire_date"
    t.string "authentication_token"
    t.string "address", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.string "social_security", default: "", null: false
    t.string "gender", default: "", null: false
    t.string "job_title", default: "", null: false
    t.string "linkedin", default: "", null: false
    t.string "picture", default: "", null: false
    t.string "access_level", default: "Employee", null: false
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.bigint "manager_id"
    t.integer "access_level_int", default: 0, null: false
    t.boolean "can_create_campaigns", default: false, null: false
    t.boolean "can_create_templates", default: false, null: false
    t.boolean "can_create_interview_reports", default: false, null: false
    t.boolean "can_read_contents", default: false, null: false
    t.boolean "can_create_contents", default: false, null: false
    t.boolean "can_create_trainings", default: false, null: false
    t.boolean "can_edit_training_workshops", default: false, null: false
    t.boolean "can_create_training_reports", default: false, null: false
    t.boolean "can_read_employees", default: false, null: false
    t.boolean "can_create_employees", default: false, null: false
    t.boolean "can_edit_employees", default: false, null: false
    t.boolean "can_edit_permissions", default: false, null: false
    t.string "provider"
    t.string "uid"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["manager_id"], name: "index_users_on_manager_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workshops", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.integer "duration", default: 0, null: false
    t.text "description", default: "", null: false
    t.string "content_type", default: "Synchronous", null: false
    t.string "image", default: "", null: false
    t.decimal "cost", precision: 15, scale: 10, default: "0.0"
    t.bigint "content_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["content_id"], name: "index_workshops_on_content_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assessment_answers", "assessment_questions"
  add_foreign_key "assessment_answers", "users"
  add_foreign_key "assessment_questions", "mods"
  add_foreign_key "attendees", "sessions"
  add_foreign_key "attendees", "users"
  add_foreign_key "campaign_drafts", "users"
  add_foreign_key "campaigns", "companies"
  add_foreign_key "campaigns", "interview_forms"
  add_foreign_key "campaigns", "users", column: "owner_id"
  add_foreign_key "categories", "companies"
  add_foreign_key "content_categories", "categories"
  add_foreign_key "content_categories", "contents"
  add_foreign_key "content_folder_links", "contents"
  add_foreign_key "content_folder_links", "folders"
  add_foreign_key "content_skills", "contents"
  add_foreign_key "content_skills", "skills"
  add_foreign_key "contents", "companies"
  add_foreign_key "csv_import_users", "users", column: "creator_id"
  add_foreign_key "folder_categories", "categories"
  add_foreign_key "folder_categories", "folders"
  add_foreign_key "folder_links", "folders", column: "child_id"
  add_foreign_key "folder_links", "folders", column: "parent_id"
  add_foreign_key "folders", "companies"
  add_foreign_key "interview_answers", "interview_questions"
  add_foreign_key "interview_answers", "interviews"
  add_foreign_key "interview_answers", "users"
  add_foreign_key "interview_form_tags", "interview_forms"
  add_foreign_key "interview_form_tags", "tags"
  add_foreign_key "interview_forms", "companies"
  add_foreign_key "interview_questions", "interview_forms"
  add_foreign_key "interview_reports", "companies"
  add_foreign_key "interview_reports", "tag_categories"
  add_foreign_key "interview_reports", "users", column: "creator_id"
  add_foreign_key "interviews", "campaigns"
  add_foreign_key "interviews", "interview_forms"
  add_foreign_key "interviews", "users", column: "creator_id"
  add_foreign_key "interviews", "users", column: "employee_id"
  add_foreign_key "interviews", "users", column: "interviewer_id"
  add_foreign_key "mods", "companies"
  add_foreign_key "objective_elements", "companies"
  add_foreign_key "objective_indicators", "objective_elements"
  add_foreign_key "objective_logs", "objective_elements"
  add_foreign_key "objective_logs", "objective_indicators"
  add_foreign_key "objective_logs", "users", column: "owner_id"
  add_foreign_key "sessions", "trainings"
  add_foreign_key "sessions", "workshops"
  add_foreign_key "skills", "skill_groups"
  add_foreign_key "tag_categories", "companies"
  add_foreign_key "tags", "companies"
  add_foreign_key "tags", "tag_categories"
  add_foreign_key "training_drafts", "users"
  add_foreign_key "training_reports", "companies"
  add_foreign_key "training_reports", "users", column: "creator_id"
  add_foreign_key "trainings", "companies"
  add_foreign_key "trainings", "folders"
  add_foreign_key "trainings", "users", column: "creator_id"
  add_foreign_key "user_forms", "mods"
  add_foreign_key "user_forms", "users"
  add_foreign_key "user_interests", "contents"
  add_foreign_key "user_interests", "folders"
  add_foreign_key "user_interests", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
  add_foreign_key "user_tags", "tag_categories"
  add_foreign_key "user_tags", "tags"
  add_foreign_key "user_tags", "users"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "users", column: "manager_id"
  add_foreign_key "workshops", "contents"
end
