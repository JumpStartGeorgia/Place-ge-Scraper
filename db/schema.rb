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

ActiveRecord::Schema.define(version: 20170302070756) do

  create_table "ad_entries", force: :cascade do |t|
    t.text     "additional_information",    limit: 65535
    t.string   "address",                   limit: 255
    t.string   "apartment_number",          limit: 255
    t.string   "area",                      limit: 255
    t.string   "area_unit",                 limit: 255
    t.string   "balcony_count",             limit: 255
    t.string   "bathroom_count",            limit: 255
    t.string   "bedroom_count",             limit: 255
    t.string   "building_number",           limit: 255
    t.string   "city",                      limit: 255
    t.integer  "city_id",                   limit: 4
    t.string   "condition",                 limit: 255
    t.string   "deal_type",                 limit: 255
    t.string   "district",                  limit: 255
    t.integer  "district_id",               limit: 4
    t.text     "features",                  limit: 65535
    t.string   "floor_number",              limit: 255
    t.string   "function",                  limit: 255
    t.boolean  "has_air_conditioning"
    t.boolean  "has_alarm"
    t.boolean  "has_appliances"
    t.boolean  "has_conference_hall"
    t.boolean  "has_doorphone"
    t.boolean  "has_electricity"
    t.boolean  "has_fireplace"
    t.boolean  "has_furniture"
    t.boolean  "has_garage_or_parking"
    t.boolean  "has_gas"
    t.boolean  "has_generator"
    t.boolean  "has_heating"
    t.boolean  "has_hot_water"
    t.boolean  "has_internet"
    t.boolean  "has_inventory"
    t.boolean  "has_lift"
    t.boolean  "has_loggia"
    t.boolean  "has_network"
    t.boolean  "has_phone"
    t.boolean  "has_security"
    t.boolean  "has_sewage"
    t.boolean  "has_storage_area"
    t.boolean  "has_tv"
    t.boolean  "has_veranda"
    t.boolean  "has_wardrobe"
    t.boolean  "has_water_supply"
    t.string   "html_copy_path",            limit: 255
    t.boolean  "is_bank_real_estate"
    t.boolean  "is_mansard"
    t.boolean  "is_urgent"
    t.string   "land_area",                 limit: 255
    t.string   "land_area_unit",            limit: 255
    t.string   "price",                     limit: 255
    t.string   "price_currency",            limit: 255
    t.string   "price_per_area_unit",       limit: 255
    t.string   "price_timeframe",           limit: 255
    t.string   "project",                   limit: 255
    t.string   "property_type",             limit: 255
    t.string   "property_sub_type",         limit: 255
    t.date     "publication_date"
    t.string   "region",                    limit: 255
    t.integer  "region_id",                 limit: 4
    t.string   "room_count",                limit: 255
    t.string   "seller_name",               limit: 255
    t.string   "seller_type",               limit: 255
    t.string   "status",                    limit: 255
    t.string   "telephone_number",          limit: 255
    t.datetime "time_of_scrape"
    t.string   "total_floor_count",         limit: 255
    t.string   "street",                    limit: 255
    t.integer  "street_id",                 limit: 4
    t.boolean  "has_stained_glass_windows"
    t.text     "distance_from_main_road",   limit: 65535
    t.text     "distance_from_tbilisi",     limit: 65535
    t.integer  "ad_id",                     limit: 4
    t.integer  "property_id",               limit: 4
    t.boolean  "is_primary"
  end

  add_index "ad_entries", ["ad_id"], name: "index_ad_entries_on_ad_id", using: :btree
  add_index "ad_entries", ["area"], name: "index_ad_entries_on_area", using: :btree
  add_index "ad_entries", ["city_id"], name: "index_ad_entries_on_city_id", using: :btree
  add_index "ad_entries", ["deal_type"], name: "index_ad_entries_on_deal_type", using: :btree
  add_index "ad_entries", ["district_id"], name: "index_ad_entries_on_district_id", using: :btree
  add_index "ad_entries", ["is_primary"], name: "index_ad_entries_on_is_primary", using: :btree
  add_index "ad_entries", ["land_area"], name: "index_ad_entries_on_land_area", using: :btree
  add_index "ad_entries", ["price"], name: "index_ad_entries_on_price", using: :btree
  add_index "ad_entries", ["price_currency"], name: "index_ad_entries_on_price_currency", using: :btree
  add_index "ad_entries", ["price_timeframe"], name: "index_ad_entries_on_price_timeframe", using: :btree
  add_index "ad_entries", ["property_id"], name: "index_ad_entries_on_property_id", using: :btree
  add_index "ad_entries", ["property_type"], name: "index_ad_entries_on_property_type", using: :btree
  add_index "ad_entries", ["publication_date"], name: "index_ad_entries_on_publication_date", using: :btree
  add_index "ad_entries", ["region_id"], name: "index_ad_entries_on_region_id", using: :btree
  add_index "ad_entries", ["room_count"], name: "index_ad_entries_on_room_count", using: :btree
  add_index "ad_entries", ["street_id"], name: "index_ad_entries_on_street_id", using: :btree

  create_table "ads", force: :cascade do |t|
    t.integer "place_ge_id",            limit: 4
    t.string  "link",                   limit: 255
    t.boolean "has_unscraped_ad_entry"
  end

  add_index "ads", ["link"], name: "index_ads_on_link", using: :btree
  add_index "ads", ["place_ge_id"], name: "index_ads_on_place_ge_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.datetime "created_at"
  end

end
