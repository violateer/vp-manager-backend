Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      # /api/v1
      resource :session, only: [:create, :destroy]
      resource :login, only: [:create]
      resource :register, only: [:create]
      resource :me, only: [:show]
      resources :projects
      resources :menus do
        collection  do
          get :tree
          get :list
        end
      end
    end
  end
end
