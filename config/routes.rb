# $Id$

ActionController::Routing::Routes.draw do |map|
  
  # Singleton resources
  map.resource :account_setup, :controller => 'account_setup', :member => {
    :personal_info => :get, :backup_sources => :get
  }
  map.resource :profile
  map.resource :facebook_profile
  map.resource :fb, :controller => 'fb'
  map.resource :timeline
  map.resource :wysiwyg_preview
  map.resource :backup_state
  map.resource :facebook_backup, :controller => 'facebook_backup', :member => { 
    :check_auth => :get, :permissions => :get, :authorized => :get, :cancel => :get }
  map.resource :image_gallery, :controller => 'image_gallery'
  map.resource :user_search, :controller => 'user_search'
  
  # regular resources
  map.resources :timeline_events, :collection => {
    :events => :get
  }
  map.connect 'tl_details/:id/:type/:events', :controller => 'timeline_events', :action => 'index'
  map.item_details 'tl_details/:id/:type/:events', :controller => 'timeline_events', :action => 'index'
  
  map.resources :dev_staging_maps
  map.resources :backup_sites
  map.resources :backup_sources, :collection => {
    :add_feed_url => :post,
    :add_twitter => :get,
    :add_picasa => :get,
    :twitter_auth => :get,
    :picasa_auth => :get
  }
  map.resources :backup_source_jobs, :member => { :progress => :get }
  map.resources :account_settings, :member => {
    :completed_steps => :get,
    },
    :collection => {
      :online => :get, :save_personal_info => :post,
      :personal_info => :get, :facebook_sync => :get, :email => :get,
      :your_history => :get, :upgrades => :get, :billings => :get,
      :always_sync_with_facebook => :get, :select_region => :get, 
      :new_address => :post, :remove_address => :delete,
      :new_school => :post, :remove_school => :delete, 
      :new_job => :post, :remove_job => :delete,
      :new_medical => :post, :remove_medical => :delete,
      :new_medical_condition => :post, :remove_medical_condition => :delete,
      :new_family => :post, :remove_family => :delete,
      :new_relationship => :post, :remove_relationship => :delete,
      :backup_contact_emails => :post, 
      :set_feed_rss_url => :put
  }
  #map.resources :email_accounts
  map.resources :gmail_accounts
  map.resources :backup_emails
  map.connect 'backup_emails/body/:id', :controller => 'backup_emails', :action => 'body'
  map.resources :feed_entries
  map.resources :backup_photo_albums
  map.resources :facebook_activity_stream_items
  map.resources :twitter_activity_stream_items
  
  # Redirect requests to flashrecorder xml config file to proper location
  map.connect ':anywhere/flashrecorder.xml', :controller => 'recordings', 
    :action => 'flashrecorder', :format => 'xml'
  
  map.resources :user_sessions, :comments, :content_authorizations, :documents, 
    :audio, :musics, :videos, :web_videos, :photos, :invitations, :address_books, 
    :guests, :recordings, :guest_invitations, :password_resets,
    :jobs, :families, :medicals, :medical_conditions, :relationships

  map.resources :users , :member => { :suspend   => :put,
                                     :unsuspend => :put,
                                     :purge     => :delete },
      :collection => {:link_user_accounts => :get}
  
  map.resources :contents, :collection => { :edit_selection => :post, 
      :gallery => :get }
      
  map.resources :stories do |stories|  
    stories.resources :elements
  end
    
  map.resources :messages do |messages|
    messages.resources :decorations, :collection => { :sort => :post, 
        :create_from_selection => :post }
  end    
  
  map.resources :elements do |elements|
    elements.resources :decorations, :collection => { :sort => :post, 
      :create_from_selection => :post }
  end
  
  map.resources :documentaries, :collection => { :post_recording => :get } do |docs|
    docs.resources :decorations, :collection => { 
      :sort => :post, :create_from_selection => :post 
    }
  end
    
  map.resources :addresses, :collection => { :country_regions => :get }
  map.resources :trustees, :collection => { :confirmation => [:get, :post] }
  
  map.resources :prelaunch, :controller => "prelaunch"
  map.connect 'prelaunch/*keywords', :controller => 'prelaunch', :action => 'index'
  map.connect 'fb/*keywords', :controller => 'prelaunch', :action => 'index'
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # Required for openid redirect w/ restful auth
  # map.open_id_complete 'session', :controller => 'sessions', :action => "create", :requirements => { :method => :get }
  #map.resource :session
  
  # Named routes
  map.about '/about', :controller => 'about'
  map.signup '/invitation/:invitation_token/:plan', :controller => 'accounts', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.login '/login', :controller => 'user_sessions', :action => 'new', :secure => true
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.member_home '/member_home', :controller => 'timelines', :action => 'show', :protocol => 'http'
  map.begin_story '/begin_story', :controller => 'stories', :action => 'begin_story'
  map.timeline_search '/timeline/search/:format/:id/:start_date/:end_date/*filters', 
    :controller => 'timelines', :action => "search"
  map.auto_complete ':controller/:action', :requirements => { :action => /auto_complete_for_\w+/ },
    :conditions => { :method => :get }
  
  # Begin SaaS Kit routes
  map.plans '/signup', :controller => 'accounts', :action => 'plans', :requirements => { :method => :get }
  map.connect '/signup/d/:discount', :controller => 'accounts', :action => 'plans'
  map.thanks '/signup/thanks', :controller => 'accounts', :action => 'thanks'
  map.create '/signup/create/:discount', :controller => 'accounts', :action => 'create', :discount => nil
  map.resource :account, :collection => { :dashboard => :get, :thanks => :get, :plans => :get, :billing => :any, :paypal => :any, :plan => :any, :cancel => :any, :canceled => :get }
  map.new_account '/signup/:plan/:discount', :controller => 'accounts', :action => 'new', :discount => nil  
  map.forgot_password '/account/forgot', :controller => 'sessions', :action => 'forgot'
  map.reset_password '/account/reset/:token', :controller => 'sessions', :action => 'reset'
    
  map.with_options(:conditions => {:subdomain => AppConfig['admin_subdomain']}) do |subdom|
    subdom.root :controller => 'subscription_admin/subscriptions', :action => 'index'
    subdom.with_options(:namespace => 'subscription_admin/', :name_prefix => 'admin_', :path_prefix => nil) do |admin|
      admin.resources :subscriptions, :member => { :charge => :post }
      admin.resources :accounts
      admin.resources :subscription_plans, :as => 'plans'
      admin.resources :subscription_discounts, :as => 'discounts'
      admin.resources :subscription_affiliates, :as => 'affiliates'
    end
  end
  # End SaaS Kit routes
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home", :action => 'index'         
  map.home ':page', :controller => 'home', :action => 'show'
  
  #UJS::routes
    
  # See how all your routes lay out with "rake routes"
  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action.:format'
end
