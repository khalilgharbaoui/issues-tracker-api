# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'v1/issues#index'

  scope module: :v2, constraints: ApiVersion.new('v2') do
    resources :issues, only: :index
  end

  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :issues, only: %i[index show create update destroy]
  end

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
