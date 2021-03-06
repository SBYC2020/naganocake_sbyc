Rails.application.routes.draw do
# 会員側のルーティング
  devise_for :customers, controllers: {
  	sessions:      'devise/customers/sessions',
  	registrations: 'devise/customers/registrations'
  }

  root 'home#top'
  get '/', to: 'home#top'
  resources :carts, only: [:index, :create, :destroy, :update]
  delete 'cart/empty', to: 'carts#empty_cart'
  resources :shipping_addresses, only: [:index, :edit, :create, :update, :destroy]
  resources :orders, only: [:new, :create, :index, :show]
  get 'order/confirm', to: 'orders#confirm'
  get 'order/finish', to: 'orders#finish'
  resources :products, only: [:show, :index]

  resource :customer, only: [:show, :edit, :update, :destroy]
  get 'customers/confirm', to: 'customers#confirm'
  put 'customers/hide', to: 'customers#hide'


# 管理者側のルーティング
  devise_for :admins, controllers: {
  	sessions:      'devise/admins/sessions',
 	registrations: 'devise/admins/registrations'
  }

  namespace :admin do
  	resources :customers, only: [:index, :show, :edit, :update]
  	resources :genres, only: [:index, :edit, :create, :update]
  	root to: 'home#top'
  	resources :orders, only: [:index, :show, :update]
  	resources :products, only: [:index, :new, :show, :edit, :create, :update]
  	resources :product_items, only: [:update]

    post 'products/new', to: 'products#create'
  end
end
