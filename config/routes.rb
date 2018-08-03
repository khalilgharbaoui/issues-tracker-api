Rails.application.routes.draw do
  get '/issues', to: 'issues#index'
  get '/issues/:id', to: 'issues#show'
  post '/issues', to: 'issues#create'
end
