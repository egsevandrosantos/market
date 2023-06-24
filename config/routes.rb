Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      get 'health_check', to: 'health_check#index', as: :health_check
      resources :companies, only: [:create, :show]
      get 'companies', to: 'companies#show_by_token', as: :company_show_by_token
    end
  end
end
