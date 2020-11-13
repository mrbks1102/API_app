Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/ideas', to: 'ideas#index'
  post '/ideas', to: 'ideas#create'
end
