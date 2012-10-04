APP_NAME::Application.routes.draw do

  match "/auth/:provider/callback", to: "sessions#create"
  match "/auth/failure", to: "sessions#failure"
  match "/sign_out", to: "sessions#destroy", as: "sign_out"
  match "/sign_in" => redirect("/auth/google_oauth2"), as: "sign_in"
  match "/dashboard", to: "users#dashboard", as: "dashboard"
  match "/help", to: "pages#help", as: :help

  resources :sessions
  resources :users

  root :to => 'pages#help'

end
