require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  resource :cart do
    collection do
      post :add_item
    end
  end

  delete "cart(/:product_id)", to: "carts#remove_item"

  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end
