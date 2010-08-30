APPNAME::Application.routes.draw do

# uncomment this
#  devise_for :users
  resources :users, :only => [:show]

  root :to => 'pages#home'

end
