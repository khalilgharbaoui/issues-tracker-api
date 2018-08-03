Rails.application.routes.draw do
  get '/issues', to: 'issues#index'
  post '/issues', to: 'issues#create'
end
