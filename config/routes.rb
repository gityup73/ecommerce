Rails.application.routes.draw do
  resources :line_items
  resources :orders


  post'add_to_cart' => 'cart#add_to_cart'

  get 'view_order' => 'cart#view_order'

  get 'checkout' => 'cart#checkout'

  get 'all' => 'storefront#all_items'

  get 'categorical' =>'storefront#items_by_category'

  get 'branding' => 'storefront#items_by_brand'

  devise_for :users
  resources :categories
  resources :products

  root 'storefront#all_items'

  get 'categories' =>'categories#index'

  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
