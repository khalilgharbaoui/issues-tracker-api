Rails.application.routes.draw do
  get '/issues', to: 'issues#index'
end
