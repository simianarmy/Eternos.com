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

ActiveRecord::Schema.define(:version => 20090624162633) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_domain"
    t.integer  "subscription_discount_id"
    t.string   "state"
  end

  add_index "accounts", ["subscription_discount_id"], :name => "index_accounts_on_subscription_discount_id"

  create_table "activity_stream_items", :force => true do |t|
    t.datetime "published_at"
    t.datetime "edited_at"
    t.string   "guid"
    t.text     "message"
    t.text     "attachment_data"
    t.string   "attachment_type"
    t.string   "activity_type"
    t.string   "type"
    t.integer  "activity_stream_id", :null => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_stream_items", ["activity_stream_id"], :name => "index_activity_stream_items_on_activity_stream_id"

  create_table "activity_streams", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.datetime "last_activity_at"
  end

  add_index "activity_streams", ["user_id"], :name => "index_activity_streams_on_user_id"

  create_table "address_books", :force => true do |t|
    t.integer  "user_id",            :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "website"
    t.string   "icq"
    t.string   "skype"
    t.string   "msn"
    t.string   "aol"
    t.binary   "ssn_b"
    t.date     "birthdate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "middle_name"
    t.string   "name_suffix"
    t.string   "gender"
    t.string   "timezone"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "name_title"
  end

  add_index "address_books", ["user_id"], :name => "index_address_books_on_user_id"

  create_table "addresses", :force => true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "location_type",    :null => false
    t.string   "street_2"
    t.integer  "region_id"
    t.integer  "country_id"
    t.string   "custom_region"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street_1",         :null => false
    t.string   "city",             :null => false
    t.string   "postal_code",      :null => false
    t.integer  "user_id"
    t.date     "moved_out_on"
    t.date     "moved_in_on"
  end

  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

  create_table "albums", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_settings", :force => true do |t|
    t.binary  "master_c"
  end
  
  create_table "av_attachments", :force => true do |t|
    t.integer  "av_attachable_id"
    t.string   "av_attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recording_id"
  end

  create_table "backup_emails", :force => true do |t|
    t.integer  "backup_source_id", :null => false
    t.string   "message_id"
    t.string   "mailbox"
    t.string   "subject"
    t.binary   "subject_encrypted"
    t.string   "sender"
    t.string   "s3_key"
    t.integer  "size"
    t.datetime "received_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end
  add_index "backup_emails", ["backup_source_id"], :name => "index_backup_emails_on_backup_source_id"

  create_table "backup_job_archives", :force => true do |t|
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "status_id"
    t.integer  "size"
    t.text     "messages"
    t.integer  "user_id"
    t.text     "error_messages"
  end

  add_index "backup_job_archives", ["finished_at"], :name => "finished_at"
  add_index "backup_job_archives", ["user_id"], :name => "user_id"

  create_table "backup_jobs", :force => true do |t|
    t.integer  "percent_complete"
    t.integer  "size"
    t.string   "status"
    t.integer  "user_id"
    t.boolean  "cancelled",        :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "finished_at"
    t.text     "error_messages"
  end

  add_index "backup_jobs", ["user_id"], :name => "index_backup_jobs_on_user_id"

  create_table "backup_photo_albums", :force => true do |t|
    t.integer  "backup_source_id",                :null => false
    t.string   "source_album_id",                 :null => false
    t.string   "cover_id",                        :null => true
    t.integer  "size",             :default => 0, :null => false
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "modified"
  end

  add_index "backup_photo_albums", ["backup_source_id"], :name => "index_backup_photo_albums_on_backup_source_id"
  add_index "backup_photo_albums", ["source_album_id"], :name => "index_backup_photo_albums_on_source_album_id"

  create_table "backup_photos", :force => true do |t|
    t.integer  "backup_photo_album_id",                    :null => false
    t.string   "source_photo_id",                          :null => false
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "source_url"
    t.string   "caption"
    t.string   "tags"
    t.string   "state"
    t.text     "download_error"
  end

  add_index "backup_photos", ["backup_photo_album_id"], :name => "index_backup_photos_on_backup_photo_album_id"
  add_index "backup_photos", ["source_photo_id"], :name => "index_backup_photos_on_source_photo_id"

  create_table "backup_sites", :force => true do |t|
    t.string "name", :null => false
    t.string "type"
  end

  add_index "backup_sites", ["name"], :name => "index_backup_sites_on_name"

  create_table "backup_source_days", :force => true do |t|
    t.date     "backup_day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id",        :default => 0,     :null => false
    t.boolean  "in_progress",      :default => false, :null => false
    t.integer  "backup_source_id"
    t.boolean  "skip",             :default => false, :null => false
    t.integer  "skip_count",       :default => 0,     :null => false
  end

  add_index "backup_source_days", ["backup_day"], :name => "backup_dates", :unique => true

  create_table "backup_source_jobs", :force => true do |t|
    t.integer  "backup_job_id"
    t.integer  "backup_source_id"
    t.integer  "size"
    t.integer  "days"
    t.datetime "created_at"
    t.integer  "status",           :default => 0, :null => false
    t.text     "messages"
    t.text     "error_messages"
    t.datetime "finished_at"
    t.integer  "percent_complete", :default => 0, :null => false
  end

  add_index "backup_source_jobs", ["backup_job_id", "backup_source_id"], :name => "backup_job_source", :unique => true
  add_index "backup_source_jobs", ["backup_job_id"], :name => "index_backup_source_jobs_on_backup_job_id"

  create_table "backup_sources", :force => true do |t|
    t.string   "type"
    t.string   "auth_login"
    t.string   "auth_password"
    t.string   "rss_url"
    t.boolean  "auth_confirmed",         :default => false, :null => false
    t.string   "auth_error"
    t.datetime "last_backup_at"
    t.date     "latest_day_backed_up"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "backup_site_id"
    t.boolean  "disabled",               :default => false, :null => false
    t.boolean  "skip_video",             :default => false, :null => false
    t.date     "earliest_day_backed_up"
    t.boolean  "needs_initial_scan",     :default => true,  :null => false
    t.datetime "last_login_attempt_at"
    t.datetime "last_login_at"
  end
  add_index "backup_sources", ["user_id"]
  add_index "backup_sources", ["backup_site_id"]
  
  create_table "backup_states", :force => true do |t|
    t.datetime "last_successful_backup_at"
    t.datetime "last_failed_backup_at"
    t.datetime "last_backup_finished_at"
    t.boolean  "in_progress"
    t.boolean  "disabled"
    t.text     "last_errors"
    t.text     "last_messages"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_backup_job_id"
    t.boolean  "items_saved"
  end

  add_index "backup_states", ["user_id"], :name => "index_backup_states_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "global",     :default => false
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "categorizations", :force => true do |t|
    t.integer  "category_id",        :null => false
    t.integer  "categorizable_id"
    t.string   "categorizable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categorizations", ["category_id"], :name => "index_categorizations_on_category_id"

  create_table "circles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    :null => false
  end

  add_index "circles", ["user_id"], :name => "index_circles_on_user_id"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id",                        :default => 0,  :null => false
  end
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

   create_table "content_accessors", :force => true do |t|
    t.integer  "content_authorization_id"
    t.integer  "user_id"
    t.integer  "circle_id"
    t.integer  "permissions",              :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_accessors", ["content_authorization_id"], :name => "index_content_accessors_on_content_authorization_id"

  create_table "content_authorizations", :force => true do |t|
    t.integer "authorizable_id"
    t.string  "authorizable_type"
    t.integer "privacy_level",     :default => 0
  end

  create_table "contents", :force => true do |t|
    t.integer  "size",                     :default => 0,          :null => false
    t.string   "type",                     :default => "Document", :null => false
    t.string   "title",                    :default => "Document", :null => false
    t.string   "filename",                 :default => "Document", :null => false
    t.string   "thumbnail"
    t.string   "bitrate"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                  :default => 0,          :null => false
    t.string   "content_type"
    t.datetime "taken_at"
    t.string   "duration"
    t.integer  "version"
    t.string   "processing_error_message"
    t.text     "description"
    t.string   "fps"
    t.string   "state"
    t.boolean  "is_recording",             :default => false,      :null => false
    t.string   "s3_key"
  end

  create_table "countries", :force => true do |t|
    t.string "name"
    t.string "official_name"
    t.string "alpha_2_code"
    t.string "alpha_3_code"
  end

  create_table "decorations", :force => true do |t|
    t.integer  "content_id",       :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "decoratable_type", :null => false
    t.integer  "decoratable_id",   :null => false
  end

  add_index "decorations", ["content_id"], :name => "index_decorations_on_content_id"
  add_index "decorations", ["decoratable_id", "decoratable_type"], :name => "index_decorations_on_polymorph"

  create_table "deleted_accounts", :force => true do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_domain"
    t.integer  "subscription_discount_id"
    t.string   "state"
  end

  create_table "elements", :force => true do |t|
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.text     "message"
    t.string   "title"
    t.datetime "start_at"
    t.datetime "end_at"
  end

  add_index "elements", ["story_id"], :name => "index_elements_on_story_id"

  create_table "facebook_contents", :force => true do |t|
    t.integer  "profile_id", :null => false
    t.text     "friends"
    t.text     "groups"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_contents", ["profile_id"], :name => "index_facebook_contents_on_profile_id"

  create_table "families", :force => true do |t|
    t.integer  "profile_id",                    :null => false
    t.string   "name"
    t.datetime "birthdate"
    t.boolean  "living",      :default => true
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "family_type"
  end

  add_index "families", ["profile_id"], :name => "index_families_on_profile_id"

  create_table "feed_entries", :force => true do |t|
    t.integer  "feed_id",      :null => false
    t.string   "author"
    t.string   "name"
    t.text     "summary"
    t.text     "rss_content"
    t.text     "url_content"
    t.text     "categories"
    t.string   "url"
    t.datetime "published_at"
    t.datetime "created_at"
    t.string   "guid"
  end

  add_index "feed_entries", ["feed_id", "guid"], :name => "feed_guid", :unique => true
  add_index "feed_entries", ["guid"], :name => "index_feed_entries_on_guid"

  create_table "feeds", :force => true do |t|
    t.integer  "backup_source_id", :null => false
    t.string   "title"
    t.string   "url"
    t.string   "feed_url_s"
    t.string   "etag"
    t.datetime "last_modified"
    t.datetime "created_at"
  end

  add_index "feeds", ["backup_source_id"], :name => "index_feeds_on_backup_source_id"

  create_table "guest_invitations", :force => true do |t|
    t.integer  "sender_id",                        :null => false
    t.integer  "circle_id"
    t.string   "email"
    t.string   "name"
    t.string   "contact_method"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attempts",          :default => 0, :null => false
    t.boolean  "emergency_contact"
    t.string   "token"
    t.datetime "send_on"
    t.string   "status"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id",       :null => false
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["sender_id"], :name => "index_invitations_on_sender_id"

  create_table "jobs", :force => true do |t|
    t.integer "profile_id",  :null => false
    t.string  "company"
    t.string  "title"
    t.string  "description"
    t.date    "start_at"
    t.date    "end_at"
    t.text    "notes"
  end

  add_index "jobs", ["profile_id"], :name => "index_jobs_on_profile_id"

  create_table "medical_conditions", :force => true do |t|
    t.integer  "profile_id",     :null => false
    t.string   "name"
    t.text     "diagnosis"
    t.text     "treatment"
    t.text     "notes"
    t.datetime "diagnosis_date"
    t.datetime "treatment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medicals", :force => true do |t|
    t.integer  "profile_id",      :null => false
    t.string   "name"
    t.string   "blood_type"
    t.string   "disorder"
    t.string   "physician_name"
    t.string   "physician_phone"
    t.string   "dentist_name"
    t.string   "dentist_phone"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "title",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "message",     :null => false
    t.integer  "category_id"
  end

  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "notify_emails", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "sent_at"
    t.text     "referrer"
    t.text     "keywords"
  end

  add_index "notify_emails", ["email"], :name => "index_notify_emails_on_email"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "password_resets", :force => true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.string   "remote_ip"
    t.string   "token"
    t.datetime "created_at"
  end

  add_index "password_resets", ["user_id"], :name => "index_password_resets_on_user_id"

  create_table "phone_numbers", :force => true do |t|
    t.integer  "phoneable_id",   :null => false
    t.string   "phoneable_type", :null => false
    t.string   "phone_type",     :null => false
    t.string   "prefix"
    t.string   "area_code"
    t.string   "number"
    t.string   "extension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_thumbnails", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "s3_key"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id",            :null => false
    t.string   "height"
    t.string   "weight"
    t.string   "race"
    t.string   "gender"
    t.string   "religion"
    t.string   "political_views"
    t.string   "sexual_orientation"
    t.string   "nickname"
    t.string   "ethnicity"
    t.string   "children"
    t.datetime "death_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "facebook_data"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "recipients", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "alt_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipients", ["user_id"], :name => "index_recipients_on_user_id"

  create_table "recordings", :force => true do |t|
    t.integer  "user_id"
    t.string   "filename",         :null => false
    t.string   "state",            :null => false
    t.string   "processing_error"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "command"
    t.string   "command_expanded"
  end

  add_index "recordings", ["user_id"], :name => "index_recordings_on_user_id"

  create_table "regions", :force => true do |t|
    t.integer "country_id",   :null => false
    t.string  "group"
    t.string  "name"
    t.string  "abbreviation"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "guest_id"
    t.integer  "circle_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.datetime "end_at"
    t.text     "notes"
    t.datetime "start_at"
  end

  add_index "relationships", ["user_id"], :name => "index_relationships_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles_users", ["role_id"], :name => "role_id"
  add_index "roles_users", ["user_id"], :name => "user_id"

  create_table "schools", :force => true do |t|
    t.integer "profile_id",                          :null => false
    t.integer "country_id",           :default => 0, :null => false
    t.string  "name"
    t.string  "degree"
    t.string  "fields"
    t.date    "start_at"
    t.date    "end_at"
    t.string  "activities_societies"
    t.string  "awards"
    t.string  "recognitions"
    t.string  "notes"
  end

  add_index "schools", ["profile_id"], :name => "index_schools_on_profile_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "stories", :force => true do |t|
    t.integer  "user_id",                           :null => false
    t.string   "title",                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "theme_id",           :default => 0, :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "category_id"
    t.string   "type"
    t.text     "story"
  end

  add_index "stories", ["user_id"], :name => "index_stories_on_user_id"

  create_table "subscription_discounts", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.decimal  "amount",     :precision => 6, :scale => 2, :default => 0.0
    t.boolean  "percent"
    t.date     "start_on"
    t.date     "end_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscription_payments", :force => true do |t|
    t.integer  "account_id"
    t.integer  "subscription_id"
    t.decimal  "amount",          :precision => 10, :scale => 2, :default => 0.0
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "setup"
  end

  add_index "subscription_payments", ["account_id"], :name => "account_id"
  add_index "subscription_payments", ["subscription_id"], :name => "subscription_id"

  create_table "subscription_plans", :force => true do |t|
    t.string   "name"
    t.decimal  "amount",          :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_limit"
    t.integer  "renewal_period",                                 :default => 1
    t.decimal  "setup_amount",    :precision => 10, :scale => 2
    t.integer  "trial_period",                                   :default => 1
    t.boolean  "allow_subdomain",                                :default => false
  end

  create_table "subscriptions", :force => true do |t|
    t.decimal  "amount",               :precision => 10, :scale => 2
    t.datetime "next_renewal_at"
    t.string   "card_number"
    t.string   "card_expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                               :default => "trial"
    t.integer  "subscription_plan_id"
    t.integer  "account_id"
    t.integer  "user_limit"
    t.integer  "renewal_period",                                      :default => 1
    t.string   "billing_id"
  end

  add_index "subscriptions", ["account_id"], :name => "account_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",        :null => false
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.integer  "user_id"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "themes", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "time_locks", :force => true do |t|
    t.integer "lockable_id"
    t.string  "lockable_type"
    t.date    "unlock_on"
    t.integer "days_after"
    t.string  "type"
  end

  add_index "time_locks", ["lockable_id", "lockable_type"], :name => "index_time_locks_on_lockable"

  create_table "timelines", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transcodings", :force => true do |t|
    t.integer  "parent_id",                :null => false
    t.integer  "size"
    t.string   "filename"
    t.string   "width"
    t.string   "height"
    t.string   "duration"
    t.string   "video_codec"
    t.string   "audio_codec"
    t.string   "state"
    t.string   "processing_error_message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bitrate"
    t.string   "fps"
    t.string   "command"
    t.text     "command_expanded"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                                          :null => false
    t.string   "email",                                                          :null => false
    t.string   "crypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "identity_url"
    t.string   "state",                                   :default => "passive", :null => false
    t.datetime "deleted_at"
    t.integer  "invitation_id"
    t.integer  "invitation_limit",                        :default => 0,         :null => false
    t.string   "type"
    t.integer  "account_id"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "password_salt"
    t.integer  "facebook_uid",              :limit => 8
    t.datetime "last_request_at"
    t.string   "current_login_ip"
    t.datetime "current_login_at"
    t.integer  "login_count",                             :default => 0,         :null => false
    t.string   "persistence_token",                                              :null => false
    t.string   "last_login_ip"
    t.datetime "last_login_at"
    t.string   "email_hash"
    t.string   "perishable_token"
    t.integer  "failed_login_count",                      :default => 0,         :null => false
    t.string   "facebook_secret_key"
    t.string   "facebook_session_key"
    t.boolean  "always_sync_with_facebook"
  end

  add_index "users", ["email"], :name => "users_email_index"
  add_index "users", ["facebook_uid"], :name => "users_facebook_uid_index"

  create_table "dev_staging_maps", :force => true do |t|
    t.integer "dev_user_id", "staging_user_id", :null => false
  end
  
end
