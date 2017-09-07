Rails.application.routes.draw do
  
  get 'order_item/shipped'

  get 'order_item/unshipped'

  get 'order_item/toggle'

  get 'orders/index'

  get 'orders/show'

  get 'orders/new'

  get 'orders/create'

  get 'orders/edit'

  get 'orders/update'

  get 'orders/destroy'

  get 'schools/index'

  get 'schools/show'

  get 'schools/new'

  get 'schools/create'

  get 'schools/edit'

  get 'schools/update'

  get 'schools/destroy'

  # Routes for main resources
  resources :items
  resources :purchases
  resources :item_prices
  resources :orders
  resources :schools

  resources :users
  resources :sessions
  
  post 'add_to_cart/:id' => 'items#add_to_cart', :as => :add_to_cart
  get 'remove_from_cart/:id' => 'items#remove_from_cart', :as => :remove_from_cart
  get 'user/edit' => 'users#edit', :as => :edit_current_user
  get 'signup' => 'schools#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout

  get 'checkout' => 'orders#checkout', :as => :checkout

  # get 'logout' => 'users#edit', :as => :e
  
  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy

  get 'ship/:id' => 'order_items#ship', as: :ship
  get 'nonajax_ship/:id' => 'order_items#nonajax_ship', as: :nonajax_ship
  
  # Set the root url
  root :to => 'home#home'

end
