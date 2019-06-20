Rails.application.routes.draw do
  post '/teams', to: 'teams#create'
  get '/teams/:id', to: 'teams#show'
  put '/teams/:id', to: 'teams#update'
  post '/teams/:id/members', to: 'members#create'
  put '/members/:id', to: 'members#update'
  delete '/members/:id', to: 'members#destroy'
  post '/pairing_records', to: 'pairing_records#create'
  delete '/pairing_records/:id', to: 'pairing_records#destroy'
  get '/teams/:id/suggested_pairs', to: 'pairing_suggestions#show'
  post '/authentication', to: 'authentication#create'
end
