SMO::Application.routes.draw do  
  get "settings/index"

  resources :trial_expires
  resources :quickbooks
  resources :reports do
    member do
    post :send_mail
    get :job_report
    post :print
     end
    
  end
  resources :customs do
    collection do
      get :add_drop_values
      put :update_position
      get :get_dropdown_values
      get :edit_dropdown
      get :new_tab
      post :create_tab
      get :edit_table
      get :edit_table_heading
      post :create_table_fields
    end

    member do
      put :update_tab
      put :update_dropdown_values
      put :update_dropdown
      put :update_status
      put :update_table
      put :update_heading
      delete :delete_table
    end
  end

  resources :customers
  resources :jobsites do
    member do
      get :ajax_show
      get :get_id
      get :show_jobsite
      get :get_jobsite
    end
  end

  resources :settings do
    collection do 
      get   :accounting
      match :authenticate
      match :oauth_callback
      match :dis_quickbooks
      match :bluedot
      get   :sync_customer_data
      get   :sync_items
      get   :sync_employees
      get   :sync_vendors
      get   :sync_salse_person
    end
  end

  resources :roles
  
  resources :contacts do
    member do
      get :ajax_show
    end
  end

  resources :jobs do
    member do
      get :job_pdf
      put :close_job
    end
    
    collection do
      get :my_jobs
    end

  end

  resources :items do
    collection do
      get :autocomplete_items
      get :create_inventory
    end
  end
 
  resources :documents 

  resources :inventories

  resources :jobtimes do
    collection do
      post :jobtime_shedule
    end
  end
  
  resources :notes
  devise_for :users

  resources :users

  match 'users/create' => "users#create",:as => :create_user

  get "dashboards/index"

  devise_for :companies, :controllers => {:sessions => 'sessions'}

  authenticated :company do
    root :to => "dashboards#index"
  end

  authenticated :user do
    root :to => "dashboards#index"
  end

  unauthenticated :user do
    devise_scope :user do
      post "api/users/sign_in", :to => "api/users_sessions#create"
      delete "api/users/sign_out", :to => "api/users_sessions#destroy"
      post "api/users/sign_up", :to => "api/registrations#users_create"
    end
  end
  
  unauthenticated :company do
    devise_scope :company do
      get "/" => "devise/sessions#new"
      post "api/sign_in", :to => "api/sessions#create"
      delete "api/sign_out", :to => "api/sessions#destroy"
      post "api/sign_up", :to => "api/registrations#create"
      get "sign_out", :to => "devise/sessions#destroy", :as => "logout"
    end
  end

  # routes for api
  namespace :api do
    resources :customers
    resources :jobsites
    resources :notes
    resources :documents

    resources :items do
      collection do
        get :autocomplete_items
        get :create_inventory
      end
    end
    resources :inventories
    resources :jobtimes do
      collection do
        post :jobtime_shedule
      end
    end


    resources :dashboards
    resources :contacts 
    resources :jobs do
      member do
        put :close_job
      end
    end
    resources :customs do
      collection do
        post  :create_tab
      end
      member do
        put   :update_tab
        put   :update_dropdown_values
        put   :update_dropdown
        put   :update_status
      end
    end
  end
  
  # end of routes for api

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
