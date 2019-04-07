Rails.application.routes.draw do
  post '/teams', to: 'teams#create'
  get '/teams/:id', to: 'teams#show'
  post '/teams/:id/members', to: 'teams#add_member'
  post '/pairing_records', to: 'pairing_records#create'
  delete '/pairing_records/:id', to: 'pairing_records#destroy'
end
