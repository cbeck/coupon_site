ActionController::Routing::Routes.draw do |map|

  map.namespace :api do |api|
    api.resources :coupons, :collection => { :search => :post }
  end
  
  map.resources :domains, :member => {:sort_images => :post, :remove_image => :post}

  map.resources :affiliate_group_memberships, :member => {:toggle => :post}

  map.resources :affiliate_groups

  map.resources :affiliates

  map.resources :ad_placements

  map.resources :ad_blocks

  map.resources :ads

  map.resources :issue_statuses

  map.resources :contacts, :collection => {:resolved => :get}, :member => {:toggle => :post, :flag => :post}

  map.contact_us 'contact_us', :controller => 'contacts', :action => 'new'
  
  map.home '/home', :controller => 'search', :action => 'new'
  map.with_options :controller => 'search' do |s|
    s.loc_search '/s/:location/:query', :action => 'show'
    s.term_search '/s/:query', :action => 'show'
  end
  
  map.resources :search, :collection => {:change_home => :get}
  
  map.namespace :admin do |admin|
    admin.resources :users,  
      :member => { 
        :suspend   => :put,
        :unsuspend => :put,
        :purge     => :delete 
      }
  end
  
  map.resources :site_configs
  
  map.with_options :controller => 'categories' do |m|
    m.browse '/categories', :action => 'index'
    m.category1 '/category/:cat1', :action => 'show'
    m.category2 '/category/:cat1/:cat2', :action => 'show'
    m.category3 '/category/:cat1/:cat2/:cat3', :action => 'show'
  end
   
  map.with_options :controller => 'sessions' do |m|
    m.login '/login', :action => 'new'
    m.logout '/logout', :action => 'destroy'
  end
  map.resource :session
  
  map.with_options :controller => 'users' do |m|
    m.register '/register', :action => 'create'
    m.signup '/signup', :action => 'new'
    m.activate '/activate/:activation_code', :action => 'activate', :activation_code => nil 
    m.myaccount '/myaccount', :action => 'myaccount'
    m.forgot_password '/forgot_password', :action => 'forgot_password'
    m.change_password '/change_password', :action => 'change_password'
    m.initiate_reset_path '/initiate_reset', :action => 'initiate_reset'
    m.reset_password '/reset_password/:password_reset_code', :action => 'reset_password'    
  end
  
  map.resources :users do |user|
      user.resources :clipped_coupons, :collection => {:search => :get, :print => :post}
  end

  map.resources :accounts, :member => { :sort_images => :post, :remove_image => :post, :details => :get, :remove_tagging => :post } do |account|
     account.resources :businesses, :member => { 
       :sort_images => :post,
       :remove_person => :post,
       :remove_phone => :post,
       :remove_email => :post,
       :remove_website => :post,
       :remove_tagging => :post,
       :remove_image => :post,
       :details => :get
     }
     account.resources :coupon_templates, :member => {
       :offer_inputs => :post, 
       :renew => :get, 
       :replace => :get, 
       :remove_info_box => :post, 
       :remove_coupon_limitation => :post
     }  
  end
  
  map.resources :galleries, :member => { :sort_images => :post, :remove_image => :post }

  map.resources :coupons, :member => {:business => :get}
  map.resources :coupon_templates
  map.resources :limitations
  map.resources :offers
  map.resources :media, :member => { :thumb => :get, :small => :get, :medium => :get, :mini => :get }
  
  map.with_options :controller => 'site' do |m|
    m.admin '/admin', :action => 'admin'
    m.maintenance '/maintenance', :action => 'maintenance_youtube'
    m.coming_soon '/coming_soon', :action => 'coming_soon'
    m.site_login '/site_login', :action => 'site_login'
    m.about '/about', :action => 'about'
    m.business_owners '/business_owners', :action => 'business_owners'
    m.privacy 'privacy', :action => 'privacy'
    m.terms 'terms', :action => 'terms'
  end
  
  map.with_options :controller => 'reports' do |m|
    m.reports '/index', :action => 'index'
    m.expired_coupons_report '/expired_coupons_report', :action => 'expired_coupons_report'
    m.basic_coupons_report '/basic_coupons_report', :action => 'basic_coupons_report'
    m.expiring_coupons_report '/expiring_coupons_report', :action => 'expiring_coupons_report'
    m.no_active_coupons_report '/no_active_coupons_report', :action => 'no_active_coupons_report'
    m.no_redemptions_report '/no_redemptions_report', :action => 'no_redemptions_report'
    m.high_redemptions_report '/high_redemptions_report', :action => 'high_redemptions_report'
  end
  
  # map.resources :site, :collection => { :auto_complete_for_tag_name => :post } 
  map.auto_complete ':controller/:action', 
        :requirements => { :action => /auto_complete_for_\S+/ },
        :conditions => { :method => :post }
  
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
  
  map.connect "/themes/:theme/images/*filename", :controller=>'theme', :action=>'images'
  map.connect "/themes/:theme/stylesheets/*filename", :controller=>'theme', :action=>'stylesheets'
  map.connect "/themes/:theme/javascript/*filename", :controller=>'theme', :action=>'javascript'

  map.connect "/themes/*whatever", :controller=>'theme', :action=>'error'

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "search", :action => "new"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
