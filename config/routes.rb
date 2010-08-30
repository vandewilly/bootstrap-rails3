APP_NAME::Application.routes.draw do

  resources :users, :only => [:show]

  root :to => 'pages#home'

end
