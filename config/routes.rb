MyApp::Application.routes.draw do

# uncomment this
#  devise_for :users
  resources :users

  root :to => 'pages#home'

end
