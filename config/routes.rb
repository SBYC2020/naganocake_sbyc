Rails.application.routes.draw do
# 会員側のルーティング
  devise_for :customers, controllers: {
  	sessions:      'devise/customer/sessions',
  	registrations: 'devise/customer/registrations'
  }

  root 'home#top'
  resources :carts, only: [:index, :create, :destroy, :update]
  delete 'carts/empty', to: 'carts#empty_cart'
  resources :deliveries, only: [:index, :edit, :create, :update, :destroy]
  resources :orders, only: [:new, :create, :index, :show]
  get 'orders/confirm', to: 'orders#confirm'
  get 'orders/finish', to: 'orders#finish'
  resources :products, only: [:show, :index]

  resource :customers, only: [:show, :edit, :update]
  get 'customers/confirm', to: 'customers#confirm'



# 管理者側のルーティング
  devise_for :admins, controllers: {
  	sessions:      'devise/admins/sessions',
 	registrations: 'devise/admins/registrations'
  }

  namespace :admin do
  	resources :customers, only: [:index, :show, :edit, :update]
  	resources :genres, only: [:index, :edit, :create, :update]
  	get '/home', to: 'home#top'
  	resources :orders, only: [:index, :show, :update]
  	resources :products, only: [:index, :new, :show, :edit, :create, :update]
  	resources :product_items, only: [:update]
  end
end
