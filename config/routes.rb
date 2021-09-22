require 'sidekiq/web'
Rails.application.routes.draw do

  # ActionCable
  mount ActionCable.server => '/cable'

  # RailsAdmin
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Sidekiq
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Devise
  devise_for :users, only: [:omniauth_callbacks], controllers: {omniauth_callbacks: "callbacks"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  as :user do
  get 'login' => 'sessions#new', as: :new_user_session
  get 'client/success' => 'sessions#success', as: :client_session_success
  get 'signup' => 'registrations#new', as: :new_user_registration
  delete 'logout' => 'devise/sessions#destroy', as: :destroy_user_session
end

  root to: 'pages#index'
  get :settings, to: 'users#edit'
  get :dashboard, to: 'dashboard#show'
  get :app, to: 'spa#index'
  get :terms, to: 'pages#terms'
  get :privacy, to: 'pages#privacy'
  get :getting_started, to: 'pages#getting_started'
  get :features, to: 'pages#features'
  get :how_it_works, to: 'pages#how_it_works'
  get :feedback, to: 'pages#feedback'
  get :download, to: 'pages#download'
  get :premium, to: 'pages#premium'
  get '/premium/upgrade', to: 'upgrades#show'
  post '/premium/upgrade', to: 'upgrades#create'

  get 'share/:hashid', to: 'share#show', as: :share
  resources :invites, only: [:show]
  resources :users, only: [:create, :update]

  # Vesrsioned API
  namespace :api do
    scope ':api_version', constraints: { api_version: /.*/ } do
      namespace :testing do
        resource :update, only: [] do
          get ':os/:arch/:version', controller: '/api/v1/updates', action: :testing, version: /[^\/]+/
        end
      end
      resource :update, only: [] do
        get ':os/:arch/:version', action: :show, version: /[^\/]+/
      end
      resource :echo, only: [:show]
      resource :auth, only: :show
      resources :users, only: [:index, :show]
      resources :invites, only: [:index, :create]
      resources :interests, except: [:new, :edit] do
        resources :submissions, except: [:new, :edit]
        resources :interest_memberships, only: :index
      end
      resources :interest_memberships, only: [:create, :destroy]
      resources :tags, only: :index
      resources :links, only: [] do
        get :parse, on: :collection
      end
    end
  end
end
