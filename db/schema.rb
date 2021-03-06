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

ActiveRecord::Schema.define(:version => 20110308054854) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_domain"
    t.string   "state"
    t.datetime "deleted_at"
    t.string   "company_name"
    t.string   "phone_number"
    t.integer  "site_id",      :default => 0, :null => false
  end

  add_index "accounts", ["full_domain"], :name => "index_accounts_on_full_domain"

  create_table "activity_stream_items", :force => true do |t|
    t.datetime "published_at"
    t.datetime "edited_at"
    t.string   "guid"
    t.text     "message"
    t.text     "attachment_data"
    t.string   "attachment_type"
    t.string   "activity_type"
    t.string   "type"
    t.integer  "activity_stream_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author"
    t.datetime "deleted_at"
    t.text     "comment_thread"
    t.string   "source_url"
    t.text     "liked_by"
    t.string   "attribution"
    t.integer  "facebook_page_id"
  end

  add_index "activity_stream_items", ["activity_stream_id", "published_at", "guid"], :name => "index_unique_stream_hash"
  add_index "activity_stream_items", ["activity_stream_id"], :name => "index_activity_stream_items_on_activity_stream_id"
  add_index "activity_stream_items", ["published_at"], :name => "index_activity_stream_items_on_published_at"
  add_index "activity_stream_items", ["type"], :name => "index_activity_stream_items_on_type"

  create_table "activity_streams", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.datetime "last_activity_at"
  end

  add_index "activity_streams", ["user_id"], :name => "index_activity_streams_on_user_id"

  create_table "address_books", :force => true do |t|
    t.integer  "user_id",     :null => false
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
    t.string   "name_title"
  end

  add_index "address_books", ["user_id"], :name => "index_address_books_on_user_id"

  create_table "addresses", :force => true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "location_type",                    :null => false
    t.string   "street_2"
    t.integer  "region_id"
    t.integer  "country_id"
    t.string   "custom_region"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street_1",         :default => ""
    t.string   "city",                             :null => false
    t.string   "postal_code",                      :null => false
    t.integer  "user_id"
    t.date     "moved_out_on"
    t.date     "moved_in_on"
  end

  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

  create_table "albums", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "size",        :default => 0, :null => false
    t.datetime "deleted_at"
    t.text     "description"
    t.integer  "cover_id"
    t.integer  "user_id",                    :null => false
    t.string   "location"
  end

  create_table "app_settings", :force => true do |t|
    t.binary "master_c"
  end

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "changes"
    t.integer  "version",        :default => 0
    t.datetime "created_at"
  end

  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "av_attachments", :force => true do |t|
    t.integer  "av_attachable_id"
    t.string   "av_attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recording_id"
  end

  create_table "backup_emails", :force => true do |t|
    t.integer  "backup_source_id",  :null => false
    t.string   "message_id"
    t.string   "mailbox"
    t.binary   "subject_encrypted"
    t.string   "sender"
    t.string   "s3_key"
    t.integer  "size"
    t.datetime "received_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.datetime "deleted_at"
  end

  add_index "backup_emails", ["backup_source_id"], :name => "index_backup_emails_on_backup_source_id"

  create_table "backup_error_codes", :force => true do |t|
    t.integer "code",        :null => false
    t.string  "description", :null => false
    t.text    "fix_hint"
  end

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

  create_table "backup_job_errors", :force => true do |t|
    t.integer "code"
    t.string  "error_text"
    t.integer "count"
  end

  add_index "backup_job_errors", ["error_text"], :name => "index_backup_job_errors_on_error_text"

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
    t.integer  "backup_source_id",                    :null => false
    t.string   "source_album_id",                     :null => false
    t.string   "cover_id"
    t.integer  "size",                 :default => 0, :null => false
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "modified"
    t.datetime "deleted_at"
    t.datetime "last_metadata_update"
  end

  add_index "backup_photo_albums", ["backup_source_id"], :name => "index_backup_photo_albums_on_backup_source_id"
  add_index "backup_photo_albums", ["source_album_id"], :name => "index_backup_photo_albums_on_source_album_id"

  create_table "backup_photos", :force => true do |t|
    t.integer  "backup_photo_album_id", :null => false
    t.string   "source_photo_id",       :null => false
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "source_url"
    t.string   "caption"
    t.string   "tags"
    t.string   "state"
    t.text     "download_error"
    t.datetime "added_at"
    t.string   "title"
    t.datetime "deleted_at"
    t.datetime "modified_at"
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
    t.string   "backup_job_id",      :limit => 36,                :null => false
    t.integer  "backup_source_id",                                :null => false
    t.integer  "size"
    t.integer  "days"
    t.datetime "created_at"
    t.integer  "status",                           :default => 0, :null => false
    t.text     "messages"
    t.text     "error_messages"
    t.datetime "finished_at"
    t.integer  "percent_complete",                 :default => 0, :null => false
    t.integer  "backup_data_set_id",               :default => 0, :null => false
  end

  add_index "backup_source_jobs", ["backup_job_id", "backup_source_id", "backup_data_set_id"], :name => "backup_job_source_data_set", :unique => true
  add_index "backup_source_jobs", ["backup_job_id"], :name => "index_backup_source_jobs_on_backup_job_id"
  add_index "backup_source_jobs", ["backup_source_id", "backup_data_set_id"], :name => "index_backup_source_data_set"
  add_index "backup_source_jobs", ["finished_at"], :name => "index_finished_at"

  create_table "backup_sources", :force => true do |t|
    t.string   "type"
    t.string   "auth_login"
    t.string   "auth_password"
    t.string   "rss_url"
    t.boolean  "auth_confirmed",           :default => false,     :null => false
    t.string   "auth_error"
    t.datetime "last_backup_at"
    t.date     "latest_day_backed_up"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "backup_site_id"
    t.boolean  "skip_video",               :default => false,     :null => false
    t.date     "earliest_day_backed_up"
    t.boolean  "needs_initial_scan",       :default => true,      :null => false
    t.datetime "last_login_attempt_at"
    t.datetime "last_login_at"
    t.string   "auth_token"
    t.string   "auth_secret"
    t.string   "title"
    t.datetime "deleted_at"
    t.binary   "auth_secret_enc"
    t.string   "auth_password2_enc"
    t.string   "auth_login2_enc"
    t.string   "backup_state",             :default => "pending", :null => false
    t.integer  "error_notifications_sent", :default => 0,         :null => false
  end

  add_index "backup_sources", ["backup_site_id"], :name => "index_backup_sources_on_backup_site_id"
  add_index "backup_sources", ["user_id"], :name => "index_backup_sources_on_user_id"

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
    t.string   "external_id"
    t.text     "commenter_data"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable"
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
    t.string   "collection_type"
    t.integer  "collection_id"
    t.integer  "parent_id"
    t.datetime "deleted_at"
    t.string   "encodingid"
  end

  add_index "contents", ["type"], :name => "index_contents_on_type"
  add_index "contents", ["user_id"], :name => "index_contents_on_user_id"

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

  create_table "dev_staging_maps", :force => true do |t|
    t.integer "dev_user_id",        :null => false
    t.integer "staging_user_id",    :null => false
    t.string  "environment"
    t.integer "production_user_id", :null => false
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

  create_table "email_blacklists", :force => true do |t|
    t.text     "email",      :null => false
    t.datetime "created_at", :null => false
  end

  create_table "email_lists", :force => true do |t|
    t.integer "user_id",                       :null => false
    t.string  "name",                          :null => false
    t.boolean "is_enabled", :default => false, :null => false
  end

  add_index "email_lists", ["user_id"], :name => "index_email_lists_on_user_id"

  create_table "facebook_contents", :force => true do |t|
    t.text     "friends"
    t.text     "groups"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id", :null => false
  end

  add_index "facebook_contents", ["profile_id"], :name => "index_facebook_contents_on_profile_id"

  create_table "facebook_ids", :force => true do |t|
    t.integer  "facebook_uid",      :limit => 8,                    :null => false
    t.boolean  "joined",                         :default => false, :null => false
    t.datetime "last_contacted_at"
  end

  add_index "facebook_ids", ["facebook_uid"], :name => "index_facebook_ids_on_facebook_uid"

  create_table "facebook_messages", :force => true do |t|
    t.integer  "facebook_thread_id",              :null => false
    t.string   "message_id",                      :null => false
    t.integer  "author_id",          :limit => 8, :null => false
    t.text     "body"
    t.text     "attachment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "backup_source_id"
    t.datetime "deleted_at"
  end

  add_index "facebook_messages", ["facebook_thread_id"], :name => "index_facebook_messages_on_facebook_thread_id"
  add_index "facebook_messages", ["message_id"], :name => "index_facebook_messages_on_message_id"

  create_table "facebook_page_admins", :id => false, :force => true do |t|
    t.integer "facebook_page_id",    :null => false
    t.integer "facebook_account_id", :null => false
  end

  add_index "facebook_page_admins", ["facebook_account_id"], :name => "index_facebook_page_admins_on_facebook_account_id"

  create_table "facebook_pages", :force => true do |t|
    t.string   "page_id",    :null => false
    t.string   "name",       :null => false
    t.text     "url",        :null => false
    t.text     "page_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_pages", ["page_id"], :name => "index_facebook_pages_on_page_id"

  create_table "facebook_threads", :force => true do |t|
    t.integer  "folder_id",                                        :null => false
    t.integer  "parent_thread_id"
    t.string   "parent_message_id"
    t.string   "subject"
    t.boolean  "unread",                         :default => true, :null => false
    t.integer  "message_count",                  :default => 0,    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fb_object_id",      :limit => 8, :default => 0,    :null => false
    t.integer  "message_thread_id", :limit => 8,                   :null => false
    t.datetime "last_message_at"
    t.text     "recipients"
    t.integer  "backup_source_id",                                 :null => false
  end

  add_index "facebook_threads", ["backup_source_id", "folder_id", "message_thread_id"], :name => "index_facebook_threads_on_backup_source_folder_message_thread", :unique => true
  add_index "facebook_threads", ["message_thread_id"], :name => "index_facebook_threads_on_message_thread_id"

  create_table "families", :force => true do |t|
    t.integer  "profile_id",                    :null => false
    t.string   "name"
    t.datetime "birthdate"
    t.boolean  "living",      :default => true
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "family_type"
    t.datetime "died_at"
    t.integer  "person_id"
  end

  add_index "families", ["profile_id"], :name => "index_families_on_profile_id"

  create_table "feed_contents", :force => true do |t|
    t.integer  "feed_entry_id",                         :null => false
    t.text     "html_content"
    t.string   "screencap_file_name"
    t.datetime "created_at"
    t.string   "screencap_content_type"
    t.datetime "screencap_updated_at"
    t.integer  "size",                   :default => 0, :null => false
  end

  add_index "feed_contents", ["feed_entry_id"], :name => "index_feed_contents_on_feed_entry_id"

  create_table "feed_entries", :force => true do |t|
    t.integer  "feed_id",      :null => false
    t.string   "author"
    t.string   "name"
    t.text     "summary"
    t.text     "rss_content"
    t.text     "categories"
    t.string   "url"
    t.datetime "published_at"
    t.datetime "created_at"
    t.string   "guid"
    t.datetime "deleted_at"
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

  create_table "guest_relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "guest_id"
    t.integer  "circle_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer "profile_id",                     :null => false
    t.string  "company"
    t.string  "title"
    t.string  "description"
    t.date    "start_at"
    t.date    "end_at"
    t.text    "notes"
    t.boolean "current_job", :default => false, :null => false
  end

  add_index "jobs", ["profile_id"], :name => "index_jobs_on_profile_id"

  create_table "linkedin_user_certifications", :force => true do |t|
    t.string   "name"
    t.string   "authority_name"
    t.string   "number"
    t.string   "certification_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "linkedin_user_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_cmpies", :force => true do |t|
    t.text     "job_request_url"
    t.text     "job_update_description"
    t.text     "person_update_headline"
    t.text     "person_update_picture_url"
    t.integer  "company_id"
    t.integer  "update_type"
    t.integer  "job_update_id"
    t.integer  "job_update_company_id"
    t.integer  "new_position_company_id"
    t.integer  "linkedin_user_id"
    t.string   "company_name"
    t.string   "profile_update_id"
    t.string   "profile_update_first_name"
    t.string   "profile_update_last_name"
    t.string   "profile_update_headline"
    t.string   "profile_update_api_standard"
    t.string   "profile_update_site_standard"
    t.string   "profile_update_action_code"
    t.string   "profile_update_field_code"
    t.string   "job_update_title"
    t.string   "job_update_company_name"
    t.string   "job_update_location_description"
    t.string   "job_update_action_code"
    t.string   "person_update_id"
    t.string   "person_update_first_name"
    t.string   "person_update_last_name"
    t.string   "person_update_api_standard"
    t.string   "person_update_site_standard"
    t.string   "person_update_action_code"
    t.string   "old_position_title"
    t.string   "old_position_company_name"
    t.string   "new_position_title"
    t.string   "new_position_company_name"
    t.boolean  "is_commentable"
    t.boolean  "is_likable"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_comment_likes", :force => true do |t|
    t.string   "update_key"
    t.string   "update_type"
    t.string   "linkedin_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "api_standard_profile_request"
    t.string   "site_standard_profile_request"
    t.integer  "num_likes"
    t.integer  "linkedin_user_id"
    t.boolean  "is_commentable"
    t.boolean  "is_likable"
    t.boolean  "is_liked"
    t.text     "headline"
    t.text     "current_status"
    t.text     "picture_url"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_companies", :force => true do |t|
    t.text     "name"
    t.text     "industry"
    t.text     "ticker"
    t.integer  "size"
    t.boolean  "type"
    t.integer  "linkedin_user_id",                         :null => false
    t.integer  "linkedin_user_positions_linkedin_user_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_connections", :force => true do |t|
    t.string   "linkedin_id",                   :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "industry"
    t.string   "location_code"
    t.integer  "linkedin_user_id",              :null => false
    t.text     "site_standard_profile_request"
    t.text     "headline"
    t.text     "api_standard_profile_request"
    t.text     "picture_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_current_positions", :force => true do |t|
    t.integer  "linkedin_user_id", :null => false
    t.text     "title"
    t.text     "summary"
    t.boolean  "is_current"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "company_name"
    t.string   "company_id"
    t.string   "company_industry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_current_shares", :force => true do |t|
    t.text     "comment"
    t.datetime "timestamp"
    t.string   "linkedin_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "source"
    t.string   "visibility"
    t.string   "current_share_id"
    t.integer  "linkedin_user_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_educations", :force => true do |t|
    t.integer  "linkedin_user_id", :null => false
    t.string   "school_name"
    t.string   "field_of_study"
    t.string   "education_id"
    t.text     "degree"
    t.text     "activities"
    t.text     "notes"
    t.integer  "start_date"
    t.integer  "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_im_accounts", :force => true do |t|
    t.string   "im_account_type"
    t.string   "im_account_name"
    t.integer  "linkedin_user_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_languages", :force => true do |t|
    t.string   "language_name"
    t.string   "proficiency_level"
    t.string   "proficiency_name"
    t.integer  "linkedin_user_id",  :null => false
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_member_url_resources", :force => true do |t|
    t.string   "name"
    t.text     "url"
    t.integer  "linkedin_user_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_ncons", :force => true do |t|
    t.string   "linkedin_id"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "headline"
    t.text     "picture_url"
    t.text     "api_standard_profile_request"
    t.text     "site_standard_profile_request"
    t.integer  "is_commentable"
    t.integer  "is_likable"
    t.integer  "linkedin_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_past_positions", :force => true do |t|
    t.integer  "linkedin_user_id", :null => false
    t.text     "title"
    t.text     "summary"
    t.boolean  "is_current"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "company_name"
    t.string   "company_id"
    t.string   "company_industry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_patent_inventors", :force => true do |t|
    t.string   "linkedin_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "linkedin_user_patents_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_patents", :force => true do |t|
    t.integer  "linkedin_user_id", :null => false
    t.text     "title"
    t.text     "summary"
    t.text     "status_name"
    t.text     "office_name"
    t.text     "url"
    t.text     "patent_id"
    t.string   "number"
    t.string   "status_id"
    t.date     "date_of_issue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_phone_numbers", :force => true do |t|
    t.string   "phone_type"
    t.string   "phone_number"
    t.integer  "linkedin_user_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_positions", :force => true do |t|
    t.integer  "linkedin_user_id", :null => false
    t.text     "title"
    t.text     "summary"
    t.boolean  "is_current"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "company_name"
    t.string   "company_id"
    t.string   "company_industry"
    t.string   "position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_publication_authors", :force => true do |t|
    t.string   "linkedin_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "linkedin_user_publications_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_publications", :force => true do |t|
    t.integer  "linkedin_user_id", :null => false
    t.text     "title"
    t.text     "publisher_name"
    t.text     "summary"
    t.text     "url"
    t.date     "date_of_issue"
    t.string   "publication_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_recommendations_receiveds", :force => true do |t|
    t.string   "linkedin_id"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "recommendation_type"
    t.string   "recommendation_id"
    t.integer  "linkedin_user_id",    :null => false
    t.text     "recommendation_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_skills", :force => true do |t|
    t.integer  "linkedin_user_id",  :null => false
    t.string   "name"
    t.string   "proficiency_level"
    t.string   "skill_id"
    t.integer  "yeard_experience"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_twitter_accounts", :force => true do |t|
    t.string   "provider_account_name"
    t.string   "provider_account_id"
    t.integer  "linkedin_user_id",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_update_comments", :force => true do |t|
    t.string   "linkedin_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "api_standard_profile_request"
    t.string   "site_standard_profile_request"
    t.integer  "sequence_number"
    t.integer  "linkedin_user_comment_like_id"
    t.text     "comment"
    t.text     "headline"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_user_update_likes", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "linkedin_id"
    t.text     "headline"
    t.text     "picture_url"
    t.integer  "linkedin_user_comment_like_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_users", :force => true do |t|
    t.string   "linkedin_id",              :null => false
    t.integer  "backup_source_id",         :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "location_code"
    t.text     "headline"
    t.text     "industry"
    t.text     "current_status"
    t.text     "summary"
    t.text     "specialties"
    t.text     "proposal_comments"
    t.text     "associations"
    t.text     "honors"
    t.text     "interests"
    t.text     "main_address"
    t.text     "picture_url"
    t.date     "date_of_birth"
    t.boolean  "num_connections_capped"
    t.integer  "distance"
    t.integer  "num_connections"
    t.integer  "num_recommenders"
    t.datetime "current_status_timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medical_conditions", :force => true do |t|
    t.integer  "profile_id",         :null => false
    t.string   "name"
    t.text     "diagnosis"
    t.text     "treatment"
    t.text     "notes"
    t.date     "diagnosis_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "treatment_end_on"
    t.date     "treatment_start_on"
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

  create_table "mementos", :force => true do |t|
    t.integer  "user_id",                    :null => false
    t.string   "title",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "slides",                     :null => false
    t.string   "version",                    :null => false
    t.string   "soundtrack", :default => "", :null => false
    t.string   "uuid",                       :null => false
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

  create_table "people", :force => true do |t|
    t.string   "name"
    t.datetime "birthdate"
    t.datetime "died_at"
    t.boolean  "living",          :default => true
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
  end

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

  add_index "photo_thumbnails", ["parent_id"], :name => "index_photo_thumbnails_on_parent_id"

  create_table "plugin_schema_info", :id => false, :force => true do |t|
    t.string  "plugin_name"
    t.integer "version"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id",                   :null => false
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
    t.string   "photo_file_name"
    t.datetime "photo_updated_at"
    t.boolean  "always_sync_with_facebook"
    t.datetime "birthday"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "raw_texts", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "word_counts"
  end

  add_index "raw_texts", ["user_id"], :name => "index_raw_texts_on_user_id"

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
    t.integer  "user_id",          :null => false
    t.string   "filename",         :null => false
    t.string   "state",            :null => false
    t.string   "processing_error"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "command"
    t.string   "command_expanded"
    t.integer  "content_id"
  end

  add_index "recordings", ["user_id"], :name => "index_recordings_on_user_id"

  create_table "regions", :force => true do |t|
    t.integer "country_id",   :null => false
    t.string  "group"
    t.string  "name"
    t.string  "abbreviation"
  end

  create_table "relationships", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.datetime "end_at"
    t.text     "notes"
    t.datetime "start_at"
    t.integer  "profile_id"
    t.integer  "person_id"
  end

  add_index "relationships", ["profile_id"], :name => "index_relationships_on_profile_id"

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

  create_table "security_questions", :force => true do |t|
    t.integer "user_id",  :null => false
    t.text    "question"
    t.text    "answer"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "stories", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.string   "title",              :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "theme_id",           :default => 0,  :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "category_id"
    t.string   "type"
    t.text     "story"
    t.datetime "deleted_at"
  end

  add_index "stories", ["user_id"], :name => "index_stories_on_user_id"

  create_table "subscription_affiliates", :force => true do |t|
    t.string   "name"
    t.decimal  "rate",       :precision => 6, :scale => 4, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  add_index "subscription_affiliates", ["token"], :name => "index_subscription_affiliates_on_token"

  create_table "subscription_discounts", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.decimal  "amount",                 :precision => 6, :scale => 2, :default => 0.0
    t.boolean  "percent"
    t.date     "start_on"
    t.date     "end_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trial_period_extension",                               :default => 0
    t.boolean  "apply_to_recurring",                                   :default => true
    t.boolean  "apply_to_setup",                                       :default => true
  end

  create_table "subscription_payments", :force => true do |t|
    t.integer  "account_id"
    t.integer  "subscription_id"
    t.decimal  "amount",                    :precision => 10, :scale => 2, :default => 0.0
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "setup"
    t.boolean  "misc"
    t.integer  "subscription_affiliate_id"
    t.decimal  "affiliate_amount",          :precision => 6,  :scale => 2, :default => 0.0
  end

  add_index "subscription_payments", ["account_id"], :name => "account_id"
  add_index "subscription_payments", ["subscription_id"], :name => "subscription_id"

  create_table "subscription_plans", :force => true do |t|
    t.string   "name"
    t.decimal  "amount",            :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_limit",                                       :default => 0,     :null => false
    t.integer  "renewal_period",                                   :default => 1
    t.decimal  "setup_amount",      :precision => 10, :scale => 2
    t.integer  "trial_period",                                     :default => 1
    t.boolean  "allow_subdomain",                                  :default => false
    t.integer  "backup_site_limit",                                :default => 0,     :null => false
    t.integer  "disk_limit",                                       :default => 0,     :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.decimal  "amount",                    :precision => 10, :scale => 2
    t.datetime "next_renewal_at"
    t.string   "card_number"
    t.string   "card_expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                                    :default => "trial"
    t.integer  "subscription_plan_id"
    t.integer  "account_id"
    t.integer  "user_limit",                                               :default => 0,       :null => false
    t.integer  "renewal_period",                                           :default => 1
    t.string   "billing_id"
    t.integer  "subscription_discount_id"
    t.integer  "subscription_affiliate_id"
    t.integer  "backup_site_limit",                                        :default => 0,       :null => false
    t.integer  "disk_limit",                                               :default => 0,       :null => false
  end

  add_index "subscriptions", ["account_id"], :name => "account_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",        :null => false
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.integer  "tagger_id"
    t.string   "context"
    t.string   "tagger_type"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"
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

  create_table "trustees", :force => true do |t|
    t.integer  "user_id",           :null => false
    t.text     "emails"
    t.string   "relationship"
    t.string   "name"
    t.string   "contact_method"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "confirmed_at"
    t.boolean  "confirmed"
    t.datetime "last_inquiry_at"
    t.string   "security_answer"
    t.string   "security_code"
    t.string   "security_question"
    t.string   "state"
  end

  create_table "user_mailings", :force => true do |t|
    t.string   "mailer",     :null => false
    t.datetime "sent_at",    :null => false
    t.string   "recipients", :null => false
    t.string   "subject",    :null => false
  end

  add_index "user_mailings", ["recipients"], :name => "index_user_mailings_on_recipients"

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
    t.integer  "setup_step",                              :default => 0,         :null => false
    t.integer  "facebook_referrer",         :limit => 8
    t.integer  "facebook_uid",              :limit => 8
    t.datetime "last_reported"
    t.integer  "site_id",                                 :default => 0,         :null => false
  end

  add_index "users", ["email"], :name => "users_email_index"
  add_index "users", ["facebook_uid"], :name => "users_facebook_uid_index"

end
