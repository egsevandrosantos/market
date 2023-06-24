Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      get 'health_check', to: 'health_check#index', as: :health_check
      resources :companies, only: [:create, :show]
    end
  end
end
