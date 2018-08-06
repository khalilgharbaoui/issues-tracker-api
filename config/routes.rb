Rails.application.routes.draw do

  scope module: :v2, constraints: ApiVersion.new('v2') do
    resources :issues, only: :index
  end

  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    get '/issues', to: 'issues#index'
    get '/issues/:id', to: 'issues#show'
    post '/issues', to: 'issues#create'
    put '/issues/:id', to: 'issues#update'
    delete '/issues/:id', to: 'issues#destroy'
  end

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
