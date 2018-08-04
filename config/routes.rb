Rails.application.routes.draw do
  get '/issues', to: 'issues#index'
  get '/issues/:id', to: 'issues#show'
  post '/issues', to: 'issues#create'
  put '/issues/:id', to: 'issues#update'
  delete '/issues/:id', to: 'issues#destroy'

  post 'auth/login', to: 'authentication#authenticate'

  post 'signup', to: 'users#create'
end
