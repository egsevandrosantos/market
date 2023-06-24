# typed: ignore
require 'sidekiq/web'

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['sidekiq_username'] && ActiveSupport::SecurityUtils.secure_compare(password, ENV['sidekiq_password'])
  end
  mount Sidekiq::Web => '/sidekiq'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      get 'health_check', to: 'health_check#index', as: :health_check
      get 'companies', to: 'companies#show_by_token', as: :company_show_by_token
      get 'companies/active', to: 'companies#active', as: :company_active
      resources :companies, only: [:create, :show]

      scope ':domain', constraint: { domain: /\A[a-zA-Z]([a-zA-Z0-9]+[.-]?)+\z/ } do
        post 'login', to: 'login#login'
      end
    end
  end
end
