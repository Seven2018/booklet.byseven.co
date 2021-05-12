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

ActiveRecord::Schema.define(version: 2021_05_05_154442) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "training_workshop_id"
    t.bigint "creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_attendees_on_creator_id"
    t.index ["training_workshop_id"], name: "index_attendees_on_training_workshop_id"
    t.index ["user_id"], name: "index_attendees_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.string "description", default: "", null: false
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_categories_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "logo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "currents", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mods", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.integer "duration", default: 0, null: false
    t.text "content", default: "", null: false
    t.string "document", default: "", null: false
    t.bigint "company_id"
    t.string "mod_type", default: ""
    t.integer "workshop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "media"
    t.index ["company_id"], name: "index_mods_on_company_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "content", default: "", null: false
    t.string "status", default: "Unread", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "status", default: "", null: false
    t.bigint "user_id"
    t.bigint "training_workshop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["training_workshop_id"], name: "index_requests_on_training_workshop_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
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

  create_table "tag_workshops", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "training_workshop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_id"], name: "index_tag_workshops_on_tag_id"
    t.index ["training_workshop_id"], name: "index_tag_workshops_on_training_workshop_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag_name", default: "", null: false
    t.string "image", default: "", null: false
    t.bigint "company_id"
    t.bigint "tag_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_tags_on_company_id"
    t.index ["tag_category_id"], name: "index_tags_on_tag_category_id"
  end

  create_table "training_workshop_mods", force: :cascade do |t|
    t.integer "position", default: 0, null: false
    t.bigint "mod_id"
    t.bigint "training_workshop_id"
    t.string "comments", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mod_id"], name: "index_training_workshop_mods_on_mod_id"
    t.index ["training_workshop_id"], name: "index_training_workshop_mods_on_training_workshop_id"
  end

  create_table "training_workshops", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.integer "duration", default: 0, null: false
    t.integer "participant_number", default: 0, null: false
    t.text "description", default: "", null: false
    t.string "workshop_type", default: "", null: false
    t.string "image", default: "", null: false
    t.bigint "company_id"
    t.datetime "available_date"
    t.datetime "date"
    t.time "starts_at"
    t.time "ends_at"
    t.bigint "workshop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "date1"
    t.datetime "date2"
    t.datetime "date3"
    t.datetime "date4"
    t.time "starts_at1"
    t.time "starts_at2"
    t.time "starts_at3"
    t.time "starts_at4"
    t.time "ends_at1"
    t.time "ends_at2"
    t.time "ends_at3"
    t.time "ends_at4"
    t.index ["company_id"], name: "index_training_workshops_on_company_id"
    t.index ["workshop_id"], name: "index_training_workshops_on_workshop_id"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workshop_categories", force: :cascade do |t|
    t.bigint "workshop_id"
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_workshop_categories_on_category_id"
    t.index ["workshop_id"], name: "index_workshop_categories_on_workshop_id"
  end

  create_table "workshop_mods", force: :cascade do |t|
    t.integer "position", default: 0, null: false
    t.bigint "mod_id"
    t.bigint "workshop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mod_id"], name: "index_workshop_mods_on_mod_id"
    t.index ["workshop_id"], name: "index_workshop_mods_on_workshop_id"
  end

  create_table "workshop_skills", force: :cascade do |t|
    t.bigint "skill_id"
    t.bigint "workshop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["skill_id"], name: "index_workshop_skills_on_skill_id"
    t.index ["workshop_id"], name: "index_workshop_skills_on_workshop_id"
  end

  create_table "workshops", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.integer "duration", default: 0, null: false
    t.text "description", default: "", null: false
    t.string "workshop_type", default: "", null: false
    t.string "image", default: "", null: false
    t.bigint "company_id"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_workshops_on_author_id"
    t.index ["company_id"], name: "index_workshops_on_company_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assessment_answers", "assessment_questions"
  add_foreign_key "assessment_answers", "users"
  add_foreign_key "assessment_questions", "mods"
  add_foreign_key "attendees", "training_workshops"
  add_foreign_key "attendees", "users"
  add_foreign_key "categories", "companies"
  add_foreign_key "mods", "companies"
  add_foreign_key "notifications", "users"
  add_foreign_key "requests", "training_workshops"
  add_foreign_key "requests", "users"
  add_foreign_key "skills", "skill_groups"
  add_foreign_key "tag_categories", "companies"
  add_foreign_key "tag_workshops", "tags"
  add_foreign_key "tag_workshops", "training_workshops"
  add_foreign_key "tags", "companies"
  add_foreign_key "tags", "tag_categories"
  add_foreign_key "training_workshop_mods", "mods"
  add_foreign_key "training_workshop_mods", "training_workshops"
  add_foreign_key "training_workshops", "companies"
  add_foreign_key "training_workshops", "workshops"
  add_foreign_key "user_forms", "mods"
  add_foreign_key "user_forms", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
  add_foreign_key "user_tags", "tags"
  add_foreign_key "user_tags", "users"
  add_foreign_key "users", "companies"
  add_foreign_key "workshop_categories", "categories"
  add_foreign_key "workshop_categories", "workshops"
  add_foreign_key "workshop_mods", "mods"
  add_foreign_key "workshop_mods", "workshops"
  add_foreign_key "workshop_skills", "skills"
  add_foreign_key "workshop_skills", "workshops"
  add_foreign_key "workshops", "companies"
end
