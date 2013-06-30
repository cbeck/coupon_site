# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100616154655) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "billing_name"
    t.string   "internal_identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "affiliate_id"
  end

  create_table "ad_blocks", :force => true do |t|
    t.string   "location"
    t.integer  "available_placements"
    t.string   "orientation"
    t.integer  "columns"
    t.text     "stylesheet"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ad_placements", :force => true do |t|
    t.integer  "ad_block_id"
    t.integer  "ad_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "affiliate_group_id"
  end

  create_table "ads", :force => true do |t|
    t.string   "name"
    t.string   "click_url"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "affiliate_group_memberships", :force => true do |t|
    t.integer  "affiliate_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "affiliate_group_id"
  end

  create_table "affiliate_group_user_memberships", :force => true do |t|
    t.integer  "affiliate_group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "affiliate_group_user_memberships", ["affiliate_group_id"], :name => "index_affiliate_group_user_memberships_on_affiliate_group_id"
  add_index "affiliate_group_user_memberships", ["user_id"], :name => "index_affiliate_group_user_memberships_on_user_id"

  create_table "affiliate_groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "affiliates", :force => true do |t|
    t.string   "name"
    t.boolean  "billable"
    t.text     "description"
    t.string   "internal_identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "businesses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.boolean  "primary"
    t.boolean  "override_logo"
    t.datetime "deleted_at"
  end

  add_index "businesses", ["account_id"], :name => "index_businesses_on_account_id"

  create_table "clipped_coupons", :force => true do |t|
    t.string   "coupon_id"
    t.string   "user_id"
    t.boolean  "favorite"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.string   "comment",                        :default => ""
    t.datetime "created_at",                                     :null => false
    t.integer  "commentable_id",                 :default => 0,  :null => false
    t.string   "commentable_type", :limit => 15, :default => "", :null => false
    t.integer  "user_id",                        :default => 0,  :null => false
  end

  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contact_issues", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "contact_issue_id"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "issue_status_id"
    t.integer  "affiliate_group_id"
  end

  add_index "contacts", ["affiliate_group_id"], :name => "index_contacts_on_affiliate_group_id"

  create_table "coupon_limitations", :force => true do |t|
    t.integer  "coupon_template_id"
    t.integer  "limitation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_templates", :force => true do |t|
    t.string   "name"
    t.integer  "offer_id"
    t.date     "start_on"
    t.date     "expired_on"
    t.boolean  "show_location"
    t.boolean  "show_email"
    t.boolean  "show_website"
    t.boolean  "use_primary"
    t.integer  "image_id"
    t.integer  "account_id"
    t.string   "offer_values"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled"
    t.boolean  "has_custom_limitation"
    t.string   "custom_limitation"
    t.boolean  "show_phone"
    t.integer  "original_id"
  end

  create_table "coupons", :force => true do |t|
    t.integer  "coupon_template_id"
    t.integer  "business_id"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domains", :force => true do |t|
    t.string   "url"
    t.string   "theme_name"
    t.integer  "affiliate_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "analytics_code"
    t.string   "google_map_key"
  end

  create_table "email_addresses", :force => true do |t|
    t.integer  "emailable_id"
    t.string   "emailable_type"
    t.string   "address"
    t.string   "label"
    t.datetime "verified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_addresses", ["emailable_id", "emailable_type"], :name => "index_email_addresses_on_emailable_id_and_emailable_type"

  create_table "event_types", :force => true do |t|
    t.string "name"
  end

  create_table "events", :force => true do |t|
    t.integer  "eventable_id"
    t.string   "eventable_type"
    t.integer  "event_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["event_type_id"], :name => "index_events_on_event_type_id"
  add_index "events", ["eventable_id", "eventable_type"], :name => "index_events_on_eventable_id_and_eventable_type"

  create_table "galleries", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_logos"
    t.boolean  "enabled"
  end

  create_table "images", :force => true do |t|
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.string   "image_filename"
    t.integer  "image_width"
    t.integer  "image_height"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "info_boxes", :force => true do |t|
    t.integer  "coupon_template_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issue_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "limitations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state",            :limit => 2
    t.string   "postal_code"
    t.string   "country"
    t.string   "directions"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "verified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden"
  end

  add_index "locations", ["addressable_id", "addressable_type"], :name => "index_locations_on_addressable_id_and_addressable_type"

  create_table "offers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.integer  "personable_id"
    t.string   "personable_type"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["personable_id", "personable_type"], :name => "index_people_on_personable_id_and_personable_type"

  create_table "phones", :force => true do |t|
    t.integer  "callable_id"
    t.string   "callable_type"
    t.string   "number"
    t.string   "extension"
    t.string   "description"
    t.string   "phone_type"
    t.boolean  "main"
    t.datetime "verified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phones", ["callable_id", "callable_type"], :name => "index_phones_on_callable_id_and_callable_type"

  create_table "schedules", :force => true do |t|
    t.integer  "business_id"
    t.string   "sunday_open"
    t.string   "sunday_close"
    t.string   "monday_open"
    t.string   "monday_close"
    t.string   "tuesday_open"
    t.string   "tuesday_close"
    t.string   "wednesday_open"
    t.string   "wednesday_close"
    t.string   "thursday_open"
    t.string   "thursday_close"
    t.string   "friday_open"
    t.string   "friday_close"
    t.string   "saturday_open"
    t.string   "saturday_close"
    t.string   "holidays"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sunday_open_period"
    t.string   "sunday_close_period"
    t.boolean  "sunday_closed"
    t.string   "monday_open_period"
    t.string   "monday_close_period"
    t.boolean  "monday_closed"
    t.string   "tuesday_open_period"
    t.string   "tuesday_close_period"
    t.boolean  "tuesday_closed"
    t.string   "wednesday_open_period"
    t.string   "wednesday_close_period"
    t.boolean  "wednesday_closed"
    t.string   "thursday_open_period"
    t.string   "thursday_close_period"
    t.boolean  "thursday_closed"
    t.string   "friday_open_period"
    t.string   "friday_close_period"
    t.boolean  "friday_closed"
    t.string   "saturday_open_period"
    t.string   "saturday_close_period"
    t.boolean  "saturday_closed"
    t.boolean  "omit"
    t.boolean  "all_hours"
  end

  add_index "schedules", ["business_id"], :name => "index_schedules_on_business_id"

  create_table "site_configs", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.string   "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
    t.boolean  "admin"
    t.string   "zip",                       :limit => 5
    t.string   "email2"
    t.string   "email3"
    t.string   "password_reset_code",       :limit => 40
    t.boolean  "sysadmin"
    t.integer  "affiliate_group_id"
  end

  add_index "users", ["affiliate_group_id"], :name => "index_users_on_affiliate_group_id"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "websites", :force => true do |t|
    t.integer  "netable_id"
    t.string   "netable_type"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "websites", ["netable_id", "netable_type"], :name => "index_websites_on_netable_id_and_netable_type"

end
