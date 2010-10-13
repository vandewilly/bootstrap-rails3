APP_NAME::Application.routes.draw do

  match '/auth/:provider/callback', :to => 'sessions#create'

  resources :users, :only => [:show]
  resources :sessions, :only => [:new, :create, :destroy]

  root :to => 'pages#home'

end
