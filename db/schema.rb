# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_25_021809) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "corporate_name", limit: 100, null: false
    t.string "fantasy_name", limit: 100, null: false
    t.string "email", limit: 100, null: false
    t.string "domain", limit: 50, null: false
    t.string "cnpj", limit: 14, null: false
    t.integer "status", default: 1, null: false
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cnpj"], name: "index_companies_on_cnpj", unique: true
    t.index ["domain"], name: "index_companies_on_domain", unique: true
    t.index ["email"], name: "index_companies_on_email", unique: true
    t.index ["status"], name: "index_companies_on_status"
    t.index ["token"], name: "index_companies_on_token", unique: true
  end

  create_table "company_user_invitations", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "user_email", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.index ["company_id", "user_email"], name: "index_company_user_invitations_on_company_id_and_user_email", unique: true
    t.index ["company_id"], name: "index_company_user_invitations_on_company_id"
    t.index ["token"], name: "index_company_user_invitations_on_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name", limit: 100, null: false
    t.string "cpf", limit: 11, null: false
    t.string "email", limit: 100, null: false
    t.string "password_digest"
    t.bigint "company_id", null: false
    t.string "token"
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["cpf", "company_id"], name: "index_users_on_cpf_and_company_id", unique: true
    t.index ["email", "company_id"], name: "index_users_on_email_and_company_id", unique: true
    t.index ["status"], name: "index_users_on_status"
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "company_user_invitations", "companies"
  add_foreign_key "users", "companies"
end
