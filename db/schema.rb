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

ActiveRecord::Schema.define(version: 20_150_923_084_446) do
  create_table 'real_estate_ads', force: :cascade do |t|
    t.integer 'place_ge_id',            limit: 4
    t.string 'link',                   limit: 255
    t.text 'additional_information', limit: 65_535
    t.string 'address',                limit: 255
    t.string 'apartment_number',       limit: 255
    t.string 'area',                   limit: 255
    t.string 'area_unit',              limit: 255
    t.string 'balcony_count',          limit: 255
    t.string 'bathroom_count',         limit: 255
    t.string 'bedroom_count',          limit: 255
    t.string 'building_number',        limit: 255
    t.string 'city',                   limit: 255
    t.integer 'city_id',                limit: 4
    t.string 'condition',              limit: 255
    t.string 'deal_type',              limit: 255
    t.string 'district',               limit: 255
    t.integer 'district_id',            limit: 4
    t.text 'features',               limit: 65_535
    t.string 'floor_number',           limit: 255
    t.string 'function',               limit: 255
    t.boolean 'has_air_conditioning'
    t.boolean 'has_alarm'
    t.boolean 'has_appliances'
    t.boolean 'has_conference_hall'
    t.boolean 'has_doorphone'
    t.boolean 'has_electricity'
    t.boolean 'has_fireplace'
    t.boolean 'has_furniture'
    t.boolean 'has_garage_or_parking'
    t.boolean 'has_gas'
    t.boolean 'has_generator'
    t.boolean 'has_heating'
    t.boolean 'has_hot_water'
    t.boolean 'has_internet'
    t.boolean 'has_inventory'
    t.boolean 'has_lift'
    t.boolean 'has_loggia'
    t.boolean 'has_network'
    t.boolean 'has_phone'
    t.boolean 'has_security'
    t.boolean 'has_sewage'
    t.boolean 'has_showcase'
    t.boolean 'has_storage_area'
    t.boolean 'has_tv'
    t.boolean 'has_veranda'
    t.boolean 'has_wardrobe'
    t.boolean 'has_water_supply'
    t.string 'html_copy_path',         limit: 255
    t.boolean 'is_bank_real_estate'
    t.boolean 'is_mansard'
    t.boolean 'is_urgent'
    t.string 'land_area',              limit: 255
    t.string 'land_area_unit',         limit: 255
    t.string 'price',                  limit: 255
    t.string 'price_currency',         limit: 255
    t.string 'price_per_area_unit',    limit: 255
    t.string 'price_timeframe',        limit: 255
    t.string 'project',                limit: 255
    t.string 'property_type',          limit: 255
    t.date 'publication_date'
    t.string 'region',                 limit: 255
    t.integer 'region_id',              limit: 4
    t.string 'room_count',             limit: 255
    t.string 'seller_name',            limit: 255
    t.string 'seller_type',            limit: 255
    t.string 'status',                 limit: 255
    t.string 'telephone_number',       limit: 255
    t.time 'time_of_scrape'
    t.string 'total_floor_count',      limit: 255
  end
end
