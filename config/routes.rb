Rails.application.routes.draw do
  post '/teams', to: 'teams#create'
  get '/teams/:id', to: 'teams#show'
  post '/pairing_records', to: 'pairing_records#create'
end
