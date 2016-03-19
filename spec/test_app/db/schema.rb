# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151002131904) do

  create_table "active_record_survey_instance_nodes", force: :cascade do |t|
    t.integer  "active_record_survey_instance_id"
    t.integer  "active_record_survey_node_id"
    t.string   "value"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "active_record_survey_instances", force: :cascade do |t|
    t.integer  "active_record_survey_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "active_record_survey_node_maps", force: :cascade do |t|
    t.integer  "active_record_survey_node_id"
    t.integer  "parent_id"
    t.integer  "lft",                                      null: false
    t.integer  "rgt",                                      null: false
    t.integer  "depth",                        default: 0, null: false
    t.integer  "children_count",               default: 0, null: false
    t.integer  "active_record_survey_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "active_record_survey_node_maps", ["lft"], name: "index_active_record_survey_node_maps_on_lft"
  add_index "active_record_survey_node_maps", ["parent_id"], name: "index_active_record_survey_node_maps_on_parent_id"
  add_index "active_record_survey_node_maps", ["rgt"], name: "index_active_record_survey_node_maps_on_rgt"

  create_table "active_record_survey_node_translations", force: :cascade do |t|
    t.integer  "active_record_survey_node_id",              null: false
    t.string   "locale",                                    null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "text",                         default: "", null: false
  end

  add_index "active_record_survey_node_translations", ["active_record_survey_node_id"], name: "index_c26930249cea5c7217b49500a54840b61a4557f0"
  add_index "active_record_survey_node_translations", ["locale"], name: "index_active_record_survey_node_translations_on_locale"

  create_table "active_record_survey_node_validations", force: :cascade do |t|
    t.integer  "active_record_survey_node_id"
    t.string   "type"
    t.string   "value"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "active_record_survey_nodes", force: :cascade do |t|
    t.string   "type"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "active_record_survey_id"
  end

  create_table "active_record_surveys", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "name",       default: ""
  end

end
