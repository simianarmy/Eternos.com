# $Id$

ActionController::Routing::Routes.draw do |map|
  map.resource :facebook_backup, :controller => 'facebook_backup'
  map.resources :backup_sources, :collection => {:add_feed_url => :post}
  
  map.resources :account_settings, :collection => {:online => :get, :save_personal_info => :post,
                                                  :personal_info => :get, :facebook_sync => :get, :email_account => :get,
                                                  :your_history => :get, :upgrades => :get, :billings => :get,
                                                  :always_sync_with_facebook => :get, :select_region => :get, 
                                                  :add_another_address => :post, :remove_address => :delete,
                                                  :add_another_job => :post, :remove_job => :delete,
                                                  :add_another_medical => :post, :remove_medical => :delete,
                                                  :add_another_medical_condition => :post, :remove_medical_condition => :delete,
                                                  :add_another_family => :post, :remove_family => :delete,
                                                  :add_another_relationship => :post, :remove_relationship => :delete,
                                                  :backup_contact_emails => :post, :add_another_school => :post, :remove_school => :delete, 
                                                  :set_feed_rss_url => :put, :set_contact_name => :put,:set_contact_email => :put}
  map.resources :backup_sites

  # Redirect requests to flashrecorder xml config file to proper location
  map.connect ':anywhere/flashrecorder.xml', :controller => 'recordings', 
    :action => 'flashrecorder', :format => 'xml'
  
  # Singleton resources    
  map.resource :profile
  map.resource :facebook_profile
  map.resource :fb, :controller => 'fb'
  map.resource :timeline
  map.resource :wysiwyg_preview
    
  map.resources :user_sessions, :comments, :content_authorizations, :documents, 
    :audio, :videos, :web_videos, :photos, :invitations, :address_books, 
    :guests, :recordings, :guest_invitations, :password_resets
  map.resources :musics, :controller => 'music'
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
  
  map.resources :documentaries do |docs|
    docs.resources :decorations, :collection => { :sort => :post, 
      :create_from_selection => :post }
  end
    
  map.resources :addresses, :collection => { :country_regions => :post }
  
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
  map.signup '/invitation/:invitation_token', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.login '/login', :controller => 'user_sessions', :action => 'new', :secure => true
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.member_home '/member_home', :controller => 'member_home', :protocol => 'http'
  map.begin_story '/begin_story', :controller => 'stories', :action => 'begin_story'
  map.timeline_search '/timeline/search/:format/:id/:start_date/:end_date/*filters', 
    :controller => 'timelines', :action => "search", :conditions => { :method => :get }
  map.auto_complete ':controller/:action', :requirements => { :action => /auto_complete_for_\w+/ },
    :conditions => { :method => :get }
  
  # From SaaS Kit
  map.plans '/signup', :controller => 'accounts', :action => 'plans', :requirements => { :method => :get }
  map.thanks '/signup/thanks', :controller => 'accounts', :action => 'thanks'
  map.resource :account, :collection => { :dashboard => :get, :thanks => :get, :plans => :get, :billing => :any, :paypal => :any, :plan => :any, :cancel => :any, :canceled => :get }
  map.new_account '/signup/:plan', :controller => 'accounts', :action => 'new', :plan => nil
  map.forgot_password '/account/forgot', :controller => 'sessions', :action => 'forgot'
  map.reset_password '/account/reset/:token', :controller => 'sessions', :action => 'reset'
    
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home", :action => 'index'         
  map.home ':page', :controller => 'home', :action => 'show'
  
  #UJS::routes
    
  # See how all your routes lay out with "rake routes"
  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action.:format'
end
