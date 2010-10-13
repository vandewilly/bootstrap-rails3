APP_NAME::Application.routes.draw do

  match '/auth/:provider/callback', :to => 'sessions#create'

  resources :users, :only => [:show]

  root :to => 'pages#home'

end
